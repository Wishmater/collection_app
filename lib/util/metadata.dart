import 'dart:io';
import 'package:collection_app/models/item.dart';
import 'package:dartx/dartx_io.dart';
import 'package:from_zero_ui/from_zero_ui.dart';
import 'package:mlog/mlog.dart';
import 'package:video_player_platform_interface/video_player_platform_interface.dart';
import 'package:video_player_win/video_player_win.dart';


abstract class MetadataUtils {

  static Future<Item> loadMetadata(Item item) async {
    final filepath = item.getAbsoluteFilePath();
    if (filepath==null) {
      log(LgLvl.warning, 'Trying to load metadata for item without path: $item');
      return item;
    }
    log(LgLvl.info, 'Loading metadata for: $item');
    final file = File(filepath);
    final extension = file.extension;
    item.metadataLastUpdated = DateTime.now();
    item.itemType = ItemType.inferFromExtension(extension);
    final fileStats = await file.stat();
    item.filesize = fileStats.size;
    item.fileCreated = fileStats.changed; // On Windows platforms, this is instead the file creation time.
    item.fileModified = fileStats.modified;
    switch (item.itemType!) {
      case ItemType.video:
        final controller = WinVideoPlayerController.file(file);
        controller.videoEventStream.listen((event) {
          if (event.eventType==VideoEventType.initialized) {
            item.duration = event.duration;
            item.resolutionWidth = event.size?.width.round();
            item.resolutionHeight = event.size?.height.round();
          }
        });
        await controller.initialize();
        await controller.dispose();
      case ItemType.image:
        // TODO 1 Implement loading metadata for images
        // item.resolutionWidth = ???;
        // item.resolutionHeight = ???;
        log(LgLvl.error, 'Metadata loading for images not implemented: $item');
      case ItemType.audio:
        // TODO 1 Implement loading metadata for audio
        // item.duration = ???;
        log(LgLvl.error, 'Metadata loading for audio not implemented: $item');
      case ItemType.unknown:
        log(LgLvl.warning, 'Unknown type for extension $extension: $item');
      case ItemType.album:
        // TODO 1 implement loading metadata for album (probably nothing and just aggregate children when they are updated). Maybe when told to update album, just update all children
    }
    return item;
  }

}