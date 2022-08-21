import 'dart:io';
import 'package:collection_app/models/item.dart';
import 'package:collection_app/models/tag.dart';
import 'package:from_zero_ui/from_zero_ui.dart';


abstract class FileProvider {


  static final listDirectories = ApiProviderFamily<List<Tag>, String>((ref, path) {
    return ApiState(ref, (apiState) async {
      return Directory(path).list()
          .where((e) => e is Directory)
          .map((e) => DirectoryTag(e.path)).toList();
    });
  });


  static final listFiles = ApiProviderFamily<List<Item>, String>((ref, path) {
    return ApiState(ref, (apiState) async {
      return Directory(path).list()
          .where((e) => e is File)
          .map((e) => FileItem(e.path)).toList();
    });
  });


  static final hasChildren = ApiProviderFamily<bool, String>((ref, path) {
    return ApiState(ref, (apiState) async {
      try {
        await Directory(path).list()
            .firstWhere((e) => e is Directory);
      } catch (e, st) {
        // TODO 3 ideally, return false only on IterableElementError.noElement(), rethrow otherwise
        return false;
      }
      return true;
    });
  });


}