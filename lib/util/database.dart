import 'dart:async';

import 'package:collection_app/models/collection.dart';
import 'package:collection_app/models/item.dart';
import 'package:collection_app/models/tag.dart';
import 'package:collection_app/services/collection_service.dart';
import 'package:collection_app/util/logging.dart';
import 'package:dartx/dartx_io.dart';
import 'package:flutter/material.dart'; // for ValueNotifier :)
import 'package:from_zero_ui/from_zero_ui.dart';
import 'package:intl/intl.dart';
import 'package:mlog/mlog.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:uuid/uuid.dart';


abstract class DbHelper {

  static const _dbVersion = 1;
  // TODO 1 make sure all DBs are closed gracefully when exiting the app
  // TODO 1 when exiting the app, show an "are you sure message if there are DB operations pending"
  static final Map<Collection, Database> _openDatabases = {};
  static final Map<Collection, int> _nextItemId = {};
  static final datetimeFormat = DateFormat('YYYY-MM-DD hh:mm:ss');
  static int getNextItemIdForCollection(Collection collection) {
    final id = _nextItemId[collection]!;
    _nextItemId[collection] = id + 1;
    return id;
  }


  static Map<String, bool> activeDbOperations = {};
  static ValueNotifier<int> activeDbOperationsCount = ValueNotifier(0);
  static ValueNotifier<int> activeDbOperationsBlockingCount = ValueNotifier(0);
  static void _onActiveOperationChanges() {
    activeDbOperationsCount.value = activeDbOperations.length;
    activeDbOperationsCount.value = activeDbOperations.count((e) => e.value);
  }
  
  static Future<void> waitForAllDbOperationsToFinish() async {
    if (activeDbOperationsCount.value==0) return;
    final completer = Completer<void>();
    VoidCallback? listener;
    listener = () {
      if (activeDbOperationsCount.value==0) {
        activeDbOperationsCount.removeListener(listener!);
        completer.complete();
      }
    };
    activeDbOperationsCount.addListener(listener);
    return completer.future;
  }
  
  static Future<void> waitForAllBlockingDbOperationsToFinish() async {
    if (activeDbOperationsBlockingCount.value==0) return;
    final completer = Completer<void>();
    VoidCallback? listener;
    listener = () {
      if (activeDbOperationsBlockingCount.value==0) {
        activeDbOperationsBlockingCount.removeListener(listener!);
        completer.complete();
      }
    };
    activeDbOperationsBlockingCount.addListener(listener);
    return completer.future;
  }

  static Future<void> waitForCurrentDbOperationsToFinish() async {
    if (activeDbOperationsCount.value==0) return;
    final currentOperations = List<String>.from(activeDbOperations.keys);
    final completer = Completer<void>();
    VoidCallback? listener;
    listener = () {
      final toRemove = currentOperations.where((c) => !activeDbOperations.containsKey(c));
      for (final e in toRemove) {
        currentOperations.remove(e);
      }
      if (currentOperations.isEmpty) {
        activeDbOperationsCount.removeListener(listener!);
        completer.complete();
      }
    };
    activeDbOperationsCount.addListener(listener);
    return completer.future;
  }

  static Future<void> waitForCurrentBlockingDbOperationsToFinish() async {
    if (activeDbOperationsCount.value==0) return;
    final currentOperations = List<String>.from(activeDbOperations.entries.where((e) => e.value).map((e) => e.key));
    final completer = Completer<void>();
    VoidCallback? listener;
    listener = () {
      final toRemove = currentOperations.where((c) => !activeDbOperations.containsKey(c)).toList();
      for (final e in toRemove) {
        currentOperations.remove(e);
      }
      if (currentOperations.isEmpty) {
        activeDbOperationsCount.removeListener(listener!);
        completer.complete();
      }
    };
    activeDbOperationsCount.addListener(listener);
    return completer.future;
  }
  
  static Future<T> _executeDbOperation<T>(
    Collection collection,
    Future<T> Function(Database database, String operationId) operation, {
      bool isBlocking = true,
  }) async {
    final db = _openDatabases[collection]!;
    final operationId = const Uuid().v4();
    final waitFuture = waitForCurrentBlockingDbOperationsToFinish();
    activeDbOperations[operationId] = true;
    _onActiveOperationChanges();
    log (LgLvl.finer,
      'INIT DB operation $operationId $isBlocking',
      type: LgType.db,
    );
    await waitFuture;
    log (LgLvl.finer,
      'EXEC DB operation $operationId $isBlocking',
      type: LgType.db,
    );
    final result = await operation(db, operationId);
    log (LgLvl.finer,
      ' END DB operation $operationId $isBlocking',
      type: LgType.db,
    );
    activeDbOperations.remove(operationId);
    _onActiveOperationChanges();
    return result;
  }


  static Future<void> openDbForCollection(Collection collection, {
    String? dbPath,
  }) async {
    final operationId = const Uuid().v4();
    activeDbOperations[operationId] = true;
    _onActiveOperationChanges();
    dbPath ??= collection.getAbsoluteFilePathForDatabase();
    if (dbPath==null) {
      throw Exception("Collection path is null, and no custom database provided, so we don't know where to save the sqlite db :(");
    }
    final exists = await databaseFactoryFfi.databaseExists(dbPath);
    final db = await databaseFactoryFfi.openDatabase(dbPath,
      options: OpenDatabaseOptions(
        version: _dbVersion,
        onCreate: (db, version) async {
          log(LgLvl.info,
            'Creating db for collection ${collection.name} at $dbPath',
            type: LgType.db,
          );
          return _applySchemaMigration(db, 0, _dbVersion);
        },
        onUpgrade: (db, oldVersion, newVersion) async {
          log(LgLvl.info,
            'Upgrading db for collection ${collection.name} at $dbPath from ver $oldVersion to $newVersion',
            type: LgType.db,
          );
          return _applySchemaMigration(db, oldVersion, _dbVersion);
        },
      ),
    );
    _openDatabases[collection] = db;
    if (exists) {
      activeDbOperations[operationId] = false;
      _onActiveOperationChanges();
      _loadDataFromDb(collection, db);
    } else {
      _nextItemId[collection] = 1;
    }
    activeDbOperations.remove(operationId);
    _onActiveOperationChanges();
  }


  static Future<void> saveCollection(Collection collection) async {
    return _executeDbOperation<void>(collection, (db, operationId) async {
      final args = [
        collection.name,
        datetimeFormat.format(collection.added),
        datetimeFormat.tryFormat(collection.lastSeen),
        datetimeFormat.tryFormat(collection.lastModified),
        collection.baseDirectory,
      ];
      await db.execute(/*language=SQLite*/ '''
        insert into collection 
          values (?, ?, ?, ?, ?)
        on conflict (name) do update 
          set name=?, added=?, lastSeen=?, lastModified=?, baseDirectory=?;
      ''', [...args, ...args],);
    });
  }


  static Future<void> saveTagToAllCollections(Tag tag) async {
    bool done = false;
    for (final collection in collectionService.getAllCollections()) {
      if (collection.tags.contains(tag)) {
        saveTagToCollection(tag, collection);
        done = true;
      }
    }
    if (!done) {
      throw Exception('Trying to save tag $tag to all collection DBs, but it is not included in any collection');
    }
  }
  static Future<void> saveTagToCollection(Tag tag, Collection collection) async {
    return _executeDbOperation<void>(collection, (db, operationId) async {
      await db.transaction<void>((txn) async {
        final args = [
          tag.name,
          datetimeFormat.format(tag.added),
          datetimeFormat.tryFormat(tag.lastSeen),
          datetimeFormat.tryFormat(tag.lastModified),
          tag.parentTag?.name,
        ];
        // TODO 2 PERFORMANCE this can probably be way more optimized,
        //   including reducing the amount of queries, making some of them optional
        //   or allowing to add/remove specific relations instead of saving all of them
        await txn.execute(/*language=SQLite*/ '''
          insert into tag 
            values (?, ?, ?, ?, ?)
          on conflict (name) do update 
            set name=?, added=?, lastSeen=?, lastModified=?, parentTagName=?;
        ''', [...args, ...args],);
        for (final secondaryParent in tag.secondaryParentTags) {
          final args = [
            secondaryParent.name,
            tag.name,
          ];
          await txn.execute(/*language=SQLite*/ '''
            insert into tagSecondaryChildren
              values (?, ?)
            on conflict (parentTagName, childTagName) do nothing;
          ''', args,);
        }
        for (final alias in tag.aliases) {
          final args = [
            tag.name,
            alias,
          ];
          await txn.execute(/*language=SQLite*/ '''
            insert into tagAliases
              values (?, ?)
            on conflict (tagName, alias) do nothing;
          ''', args,);
        }
      });
    });
  }


  static Future<void> saveItem(Item item) async {
    return _executeDbOperation<void>(item.collection, (db, operationId) async {
      return db.transaction<void>((txn) async {
        final args = [
          item.id,
          item.name,
          datetimeFormat.format(item.added),
          datetimeFormat.tryFormat(item.lastSeen),
          datetimeFormat.tryFormat(item.lastModified),
          item.filePath,
          item.explorePriority,
          item.rating,
        ];
        // TODO 2 PERFORMANCE this can probably be way more optimized,
        //   including reducing the amount of queries, making some of them optional
        //   or allowing to add/remove specific relations instead of saving all of them
        await txn.execute(/*language=SQLite*/ '''
          insert into item 
            values (?, ?, ?, ?, ?, ?, ?, ?)
          on conflict (id) do update 
            set id=?, name=?, added=?, lastSeen=?, lastModified=?, filePath=?, explorePriority=?, rating=?;
        ''', [...args, ...args],);
        for (final tag in item.tags) {
          final args = [
            item.id,
            tag.name,
          ];
          await txn.execute(/*language=SQLite*/ '''
            insert into itemTags
              values (?, ?)
            on conflict (itemId, tagName) do nothing;
          ''', args,);
        }
      });
    });
  }


  static Future<void> _loadDataFromDb(Collection collection, Database db) async {

    _nextItemId[collection] = 1; // update with highest item id
  }


  static Future<void> _applySchemaMigration(Database db, int oldVersion, int newVersion) async {
    if (oldVersion<1 && newVersion>=1) {
      await db.execute(/*language=SQLite*/ '''
        create table collection(
          name text primary key not null,
          added datetime not null,
          lastSeen datetime,
          lastModified datetime,
          baseDirectory text
        );
        create table tag(
          name text primary key not null,
          added datetime not null,
          lastSeen datetime,
          lastModified datetime,
          parentTagName text,
          foreign key(parentTagName) references tag(name)
        );
        create table item(
          id int primary key not null,
          name text not null,
          added datetime not null,
          lastSeen datetime,
          lastModified datetime,
          filePath text,
          explorePriority int,
          rating int
        );
        create table tagSecondaryChildren(
          parentTagName text not null,
          childTagName text not null,
          primary key (parentTagName, childTagName),
          foreign key(parentTagName) references tag(name),
          foreign key(childTagName) references tag(name)
        );
        create table tagAliases(
          tagName text not null,
          alias text not null,
          primary key (tagName, alias),
          foreign key(tagName) references tag(name)
        );
        create table itemTags(
          itemId text not null,
          tagName text not null,
          primary key (itemId, tagName),
          foreign key(itemId) references item(id),
          foreign key(tagName) references tag(name)
        );
      ''');
    }
  }

}


extension DateTryFormat on DateFormat {
  String? tryFormat(DateTime? dateTime) {
    if (dateTime==null) return null;
    return format(dateTime);
  }
}