import 'dart:io';
import 'package:collection_app/models/item.dart';
import 'package:collection_app/providers/item_provider.dart';
import 'package:collection_app/util/metadata_utils.dart';
import 'package:collection_app/util/thumbnail_utils.dart';
import 'package:from_zero_ui/from_zero_ui.dart';


abstract class DataProvider {

  static final thumbnail = ApiProviderFamily<File?, Item>((ref, item) {
    return ApiState(ref, (apiState) {
      return ThumbnailUtils.ensureThumbnailCreated(item);
    });
  },
    disposeDelay: const Duration(seconds: 60),
  );

  static final metadata = ApiProviderFamily<Item, Item>((ref, item) {
    return ApiState(ref, (apiState) async {
      final result = await MetadataUtils.loadMetadata(item);
      ItemProvider.saveItem(ref, result);
      return result;
    });
  },
    disposeDelay: const Duration(seconds: 60),
  );

}