import 'dart:io';
import 'package:collection_app/models/item.dart';
import 'package:collection_app/util/video_thumbnail_utils.dart';
import 'package:from_zero_ui/from_zero_ui.dart';


abstract class DataProvider {

  static final thumbnail = ApiProviderFamily<File?, Item>((ref, item) {
    return ApiState(ref, (apiState) {
      return VideoThumbnailUtils.ensureThumbnailCreated(item);
    });
  },
    disposeDelay: const Duration(seconds: 60),
  );

}