import 'dart:async';

import 'package:collection_app/models/collection.dart';
import 'package:collection_app/models/item.dart';
import 'package:collection_app/models/tag.dart';
import 'package:collection_app/services/collection_service.dart';
import 'package:collection_app/services/item_service.dart';
import 'package:collection_app/services/tag_service.dart';
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
  static final datetimeFormat = DateFormat('yyyy-MM-dd hh:mm:ss');
  static int getNextItemIdForCollection(Collection collection) {
    final id = _nextItemId[collection]!;
    _nextItemId[collection] = id + 1;
    return id;
  }



  // SCAFFOLDING / INTERNAL DB UTILITY, USUALLY NOT CALLED FROM OUTSIDE THIS FILE

  static Map<String, bool> activeDbOperations = {};
  static ValueNotifier<int> activeDbOperationsCount = ValueNotifier(0);
  static ValueNotifier<int> activeDbOperationsBlockingCount = ValueNotifier(0);
  static void _onActiveOperationChanges() {
    activeDbOperationsCount.value = activeDbOperations.length;
    activeDbOperationsBlockingCount.value = activeDbOperations.count((e) => e.value);
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



  // DATABASE OPERATIONS AND MUTATIONS, USUALLY CALLED FROM SERVICES

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
      await _loadDataFromDb(collection, db);
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



  // DATA LOADING AND SCHEMA MIGRATIONS, SHOULD ONLY BE CALLED ONCE ON APP STARTUP

  static Future<void> _loadDataFromDb(Collection collection, Database db) async {
    // LOAD COLLECTION
    final collectionQuery = await db.rawQuery(/*language=SQLite*/ '''
      select * from collection
    ''');
    collection.name = collectionQuery[0]['name']! as String;
    collection.added = datetimeFormat.parse(collectionQuery[0]['added']! as String);
    collection.lastSeen = datetimeFormat.tryParse(collectionQuery[0]['lastSeen'] as String?);
    collection.lastModified = datetimeFormat.tryParse(collectionQuery[0]['lastModified'] as String?);
    collection.baseDirectory = collectionQuery[0]['baseDirectory'] as String?;
    // LOAD TAGS
    // TODO 2 PERFORMANCE play around more with json_group_array, to reduce query count
    final tagQuery = await db.rawQuery(/*language=SQLite*/ '''
      select tag.*
              -- json_group_array(tA.alias) as aliases, 
              -- json_group_array(tSC.parentTagName) as parents
      from tag
      -- left join tagAliases tA on tag.name = tA.tagName
      -- left join tagSecondaryChildren tSC on tag.name = tSC.childTagName
    ''');
    // first pass to add basic tag data
    final tags = <String, Tag>{};
    for (final query in tagQuery) {
      final tagName = query['name']! as String;
      final aliasesQuery = await db.rawQuery(/*language=SQLite*/ '''
        select alias 
        from tagAliases
        where tagName = ?
      ''', [tagName],);
      final tag = Tag(
        name: tagName,
        added: datetimeFormat.parse(query['added']! as String),
        lastSeen: datetimeFormat.tryParse(query['lastSeen'] as String?),
        lastModified: datetimeFormat.tryParse(query['lastModified'] as String?),
        aliases: aliasesQuery.map((e) => e['alias']! as String).toList(),
      );
      tags[tag.name] = tag;
    }
    // second pass to add relations to other tags
    for (final query in tagQuery) {
      final tag = tags[query['name']! as String]!;
      tag.parentTag = tags[query['parentTagName'] as String?];
      final secondaryParentsQuery = await db.rawQuery(/*language=SQLite*/ '''
        select parentTagName 
        from tagSecondaryChildren
        where childTagName = ?
      ''', [tag.name],);
      for (final query in secondaryParentsQuery) {
        tag.secondaryParentTags.add(tags[query['parentTagName']! as String]!);
      }
    }
    // final pass to add them to collection via service, which includes filling all reverse links info
    for (final tag in tags.values) {
      tagService.addTag(tag, collection,
        checkIfAlreadyExists: false,
        saveToDb: false,
      );
    }
    // LOAD ITEMS
    // TODO 2 PERFORMANCE play around more with json_group_array, to reduce query count
    final itemQuery = await db.rawQuery(/*language=SQLite*/ '''
      select item.*
              -- json_group_array(iT.tagName) as tags
      from item
      -- left join itemTags iT on item.id = iT.itemId
    ''');
    _nextItemId[collection] = 1;
    for (final query in itemQuery) {
      final itemId = query['id']! as int;
      final secondaryParentsQuery = await db.rawQuery(/*language=SQLite*/ '''
        select tagName 
        from itemTags
        where itemId = ?
      ''', [itemId],);
      final item = Item(
        collection: collection,
        id: itemId,
        name: query['name']! as String,
        added: datetimeFormat.parse(query['added']! as String),
        lastSeen: datetimeFormat.tryParse(query['lastSeen'] as String?),
        lastModified: datetimeFormat.tryParse(query['lastModified'] as String?),
        filePath: query['filePath'] as String?,
        explorePriority: query['explorePriority'] as int?,
        rating: query['rating'] as int?,
        tags: secondaryParentsQuery.map((e) => tags[e['tagName']! as String]!).toList(),
      );
      if (_nextItemId[collection]! <= item.id) {
        _nextItemId[collection] = item.id + 1;
      }
      itemService.addItem(collection, item,
        checkIfAlreadyExists: false,
        saveToDb: false,
      );
    }
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


extension DateFormatTry on DateFormat {
  String? tryFormat(DateTime? dateTime) {
    if (dateTime==null) return null;
    return format(dateTime);
  }
  DateTime? tryParse(String? string) {
    if (string==null) return null;
    return parse(string);
  }
}