import 'dart:io';
import 'package:flutter/material.dart';
import 'package:from_zero_ui/from_zero_ui.dart';
import 'package:mlog/mlog.dart';
import 'package:video_player/video_player.dart';

class VideoLiveThumbnail extends StatefulWidget {
  final String filePath;

  const VideoLiveThumbnail({required this.filePath, required super.key});

  @override
  State<VideoLiveThumbnail> createState() => _VideoLiveThumbnailState();
}

class _VideoLiveThumbnailState extends State<VideoLiveThumbnail> {
  late VideoPlayerController controller;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    controller = VideoPlayerController.file(File(widget.filePath));
    controller.addListener(() {
      if (controller.value.hasError) {
        log(
          LgLvl.error,
          'Error caught in video_player listener\n${controller.value.originalError}\n${controller.value.errorDescription}',
        );
      }
    });
    log(LgLvl.fine, 'Initializing video live thumbnail  --  ${widget.filePath}');
    final future = controller.initialize();
    log(LgLvl.fine, 'AFTER INIT  --  ${widget.filePath}');
    try {
      await future;
      log(LgLvl.fine, 'DONE INIT  --  ${widget.filePath}');
    } catch (e, st) {
      log(LgLvl.error, 'Error while initializing video  --  ${widget.filePath}', e: e, st: st);
    }
    // TODO: 2 we can do a lot of cool stuff here, like skipping around to show different parts of the video, at least for thumbnail of selected videos
    await controller.setVolume(0);
    await controller.seekTo(const Duration(seconds: 60));
    await controller.play();
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return VideoPlayer(controller);
  }
}
