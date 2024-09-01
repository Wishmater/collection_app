import 'dart:async';
import 'dart:io';
import 'package:collection_app/models/collection.dart';
import 'package:collection_app/util/persistence.dart';
import 'package:collection_app/util/database_backup.dart';
import 'package:collection_app/util/logging.dart';
import 'package:dartx/dartx_io.dart';
import 'package:flutter/material.dart'; // for ValueNotifier :))
import 'package:from_zero_ui/from_zero_ui.dart'; // for log :))
import 'package:intl/intl.dart';
import 'package:mlog/mlog.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:uuid/uuid.dart';


typedef DbOperation<T> = Future<T> Function(Database database, String operationId);

abstract class DbHelper {

  static const _dbVersion = 3;
  // TODO 1 when exiting the app, show an "are you sure message if there are DB operations pending"
  static final Map<Collection, Database> openDatabases = {};
  static final Map<Collection, int> nextItemId = {};
  static final datetimeFormat = DateFormat('yyyy-MM-dd hh:mm:ss');
  static int getNextItemIdForCollection(Collection collection) {
    final id = nextItemId[collection]!;
    nextItemId[collection] = id + 1;
    return id;
  }

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

  static Future<T> executeDbOperation<T>(Collection collection, DbOperation<T> operation, {
    bool isBlocking = true,
  }) async {
    final db = openDatabases[collection]!;
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
    if (isBlocking) { // assumes all blocking operations are writes, so db should be backed up afterwards
      DbBackup.notifyNeedsBackup(collection);
    }
    return result;
  }


  static Future<void> openDbForCollection(Collection collection, {
    String? dbPath,
  }) async {
    final operationId = const Uuid().v4();
    activeDbOperations[operationId] = true;
    _onActiveOperationChanges();
    await closeDbForCollection(collection);
    dbPath ??= collection.getAbsoluteFilePathForDatabase();
    if (dbPath==null) {
      throw Exception("Collection path is null, and no custom database provided, so we don't know where to save the sqlite db :(");
    }
    final dbFile = File(dbPath);
    final collectionDataRoot = dbFile.parent;
    if (!await collectionDataRoot.exists()) {
      await collectionDataRoot.create();
      if (PlatformExtended.isWindows) {
        await Process.run('attrib', ['+h', collectionDataRoot.absolute.path]); // hide folder
      }
    }
    final dbExists = await databaseFactoryFfi.databaseExists(dbPath);
    final db = await databaseFactoryFfi.openDatabase(dbPath,
      options: OpenDatabaseOptions(
        version: _dbVersion,
        singleInstance: false, // if we leave this true, there are weird bugs that cause onCreate/onUpdate to be skipped, especially when hot restarting
        onConfigure: (db) async {
          // Add support for cascade delete
          await db.execute("PRAGMA foreign_keys = ON");
        },
        onCreate: (db, version) async {
          log(LgLvl.info,
            'Creating db for collection ${collection.name} at $dbPath',
            type: LgType.db,
          );
          return Persistence.applySchemaMigration(db, 0, _dbVersion);
        },
        onUpgrade: (db, oldVersion, newVersion) async {
          log(LgLvl.info,
            'Upgrading db for collection ${collection.name} at $dbPath from ver $oldVersion to $newVersion',
            type: LgType.db,
          );
          return Persistence.applySchemaMigration(db, oldVersion, _dbVersion);
        },
      ),
    );
    openDatabases[collection] = db;
    if (dbExists) {
      activeDbOperations[operationId] = false;
      _onActiveOperationChanges();
      await Persistence.loadDataFromDb(collection, db);
    } else {
      nextItemId[collection] = 1;
    }
    activeDbOperations.remove(operationId);
    _onActiveOperationChanges();
  }

  static Future<void> closeDbForCollection(Collection collection) async {
    if (openDatabases.containsKey(collection)) {
      await openDatabases[collection]!.close();
      openDatabases.remove(collection);
    }
  }

  static Future<void> deleteDbForCollection(Collection collection, {
    String? dbPath,
  }) async {
    await closeDbForCollection(collection);
    final file = File(dbPath ?? collection.getAbsoluteFilePathForDatabase()!);
    if (await file.exists()) {
      await file.delete();
    }
  }

}