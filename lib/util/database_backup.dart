import 'dart:io';

import 'package:collection_app/models/collection.dart';
import 'package:collection_app/util/database_helper.dart';
import 'package:collection_app/util/util.dart';
import 'package:dartx/dartx_io.dart';
import 'package:from_zero_ui/from_zero_ui.dart';
import 'package:intl/intl.dart';
import 'package:mlog/mlog.dart';
import 'package:path/path.dart' as p;


class DbBackup {

  static final Map<Collection, bool> _isBackupNeeded = {};
  static final Map<Collection, DateTime> _lastBackupTime = {};
  static const Duration maxTimeBetweenBackups = Duration(minutes: 5);
  static final datetimeFormat = DateFormat('yyyy-MM-dd_hh-mm-ss');

  static void notifyNeedsBackup(Collection collection) {
    if (_isBackupNeeded[collection]??false) return;
    _isBackupNeeded[collection] = true;
    final lastBackupTime = _lastBackupTime[collection];
    final diff = lastBackupTime==null
        ? null
        : DateTime.now().difference(lastBackupTime);
    final awaitTime = diff==null
        ? Duration.zero
        : maxTimeBetweenBackups - diff;
    if (awaitTime>Duration.zero) {
      Future<void>.delayed(awaitTime).then((value) {
        _createBackup(collection);
      });
    } else {
      _createBackup(collection);
    }
  }

  static Future<void> _createBackup(Collection collection) async {
    await DbHelper.waitForAllBlockingDbOperationsToFinish();
    _isBackupNeeded[collection] = false;
    // since we're setting lastBackupTime before starting the operation,
    // we're trusting operation will never take more than maxTimeBetweenBackups
    final now = DateTime.now();
    _lastBackupTime[collection] = now;
    final db = DbHelper.openDatabases[collection]!;
    final dirPath = p.join(collection.baseDirectory!, '.collection_app',);
    final filePath = p.join(dirPath, 'database_backup_${datetimeFormat.format(now)}.db',);
    await db.execute('''
      vacuum into '$filePath' 
    ''');
    // cleanup old db files
    final Map<DateTime, File> backups = {};
    for (final file in await Directory(dirPath).list().toList()) {
      try {
        if (file is File) {
          if (file.nameWithoutExtension.startsWith('database_backup_')) {
            final dateString = file.nameWithoutExtension.substring('database_backup_'.length);
            final date = datetimeFormat.tryParse(dateString);
            if (date!=null) {
              backups[date] = file;
            }
          }
        }
      } catch (e, st) {
        log (LgLvl.error, 'Error while cleaning up db backup files', e: e, st: st,);
      }
    }
    final dates = backups.keys.toList();
    dates.sort();
    if (dates.length>3) {
      for (final date in dates.sublist(0, dates.length-3)) {
        await backups[date]!.delete();
      }
    }
  }

}