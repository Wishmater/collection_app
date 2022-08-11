import 'package:collection_app/main.dart';
import 'package:collection_app/models/collection.dart';
import 'package:collection_app/models/item.dart';
import 'package:collection_app/models/tag.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:from_zero_ui/from_zero_ui.dart';
import 'package:hive/hive.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;


abstract class IsarProvider {

  static final collections = ApiProvider<Isar>((ref) {
    return ApiState(ref, (apiState) async {
      WidgetsFlutterBinding.ensureInitialized();
      var appDir = await getApplicationDocumentsDirectory();
      return await Isar.open(
        [CollectionDataSchema],
        name: 'collections', // TODO 1 ban name 'collections' from Collection names
        directory: path.join(appDir.path, appDirectorySubDir),
      );
    });
  },
    cacheTime: const Duration(days: 999999999999),
  );

  static String? get lastOpenedCollection => Hive.box('settings').get('lastOpenedCollection');
  static set lastOpenedCollection(String? value) => Hive.box('settings').put('lastOpenedCollection', value);

  static final selectedCollectionName = StateProvider<String?>((ref) => lastOpenedCollection);
  static final openCollection = ApiProvider<Isar>((ref) {
    return ApiState(ref, (apiState) async {
      final selected = ref.watch(selectedCollectionName);
      while (selected==null) {
        await Future.delayed(const Duration(seconds: 1));
      }
      WidgetsFlutterBinding.ensureInitialized();
      var appDir = await getApplicationDocumentsDirectory();
      return await Isar.open(
        [TagSchema, ItemSchema],
        name: selected,
        directory: path.join(appDir.path, appDirectorySubDir),
      );
    });
  },
    cacheTime: const Duration(days: 999999999999),
  );

}