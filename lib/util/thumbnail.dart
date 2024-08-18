import 'dart:io';
import 'package:collection_app/models/collection.dart';
import 'package:collection_app/models/item.dart';
import 'package:from_zero_ui/from_zero_ui.dart';
import 'package:mlog/mlog.dart';


abstract class ThumbnailUtils {

  static Future<Directory?> ensureThumbnailFolderCreated(Collection collection) async {
    final folderPath = collection.getAbsoluteFilePathForThumbnailsFolder();
    if (folderPath==null) return null;
    final thumbnailsFolder = Directory(folderPath);
    if (!await thumbnailsFolder.exists()) {
      await thumbnailsFolder.create(recursive: true);
    }
    return thumbnailsFolder;
  }

  static Future<File?> ensureThumbnailCreated(Item item) async {
    final thumbnailsFolder = await ensureThumbnailFolderCreated(item.collection);
    if (thumbnailsFolder==null) return null;
    final path = item.getAbsoluteFilePathForThumbnail();
    if (path==null) return null;
    final thumbnail = File(path);
    if (!await thumbnail.exists()) {
      return createThumbnail(item, thumbnail: thumbnail);
    }
    return thumbnail;
  }


  static Future<File?> createThumbnail(Item item, {
    File? thumbnail,
  }) async {
    if (thumbnail==null) {
      final path = item.getAbsoluteFilePath();
      if (path==null) return null;
      thumbnail = File(path);
    }
    final thumbnailParentFolder = thumbnail.parent;
    if (!await thumbnailParentFolder.exists()) {
      await thumbnailParentFolder.create(recursive: true);
    }
    final itemPath = item.getAbsoluteFilePath();
    if (itemPath==null) return null;
    log(LgLvl.info, 'Creating thumbnail for: $itemPath');
    // using ffmpeg directly to create thumbnails
    // assumes ffmpeg is installed and set as an env variable, will crash otherwise
    // good flutter implementations not really found... https://pub.dev/packages/thumblr
    // we could also try a flutter wrapper for ffmpeg:
    //   - https://github.com/arthenica/ffmpeg-kit/issues/8
    //   - https://pub.dev/packages/ffmpeg_helper
    final result = await Process.run('ffmpeg', [
      '-ss', '00:00:10.000',
      '-i', itemPath,
      '-vf', 'scale=320:180:force_original_aspect_ratio=decrease',
      '-vframes', '1',
      thumbnail.absolute.path,
    ],);
    if (result.exitCode!=0) {
      log(LgLvl.error, 'Error while creating thumbnail for: $itemPath\n${result.stderr}');
      return null;
    }
    return thumbnail;
  }

}