import 'dart:io';
import 'package:flutter/material.dart';
import 'package:from_zero_ui/from_zero_ui.dart';
import 'package:mlog/mlog.dart';
import 'package:video_player_platform_interface/video_player_platform_interface.dart';
import 'package:video_player_win/video_player_win.dart';

class VideoLiveThumbnail extends StatefulWidget {
  final String filePath;

  const VideoLiveThumbnail({required this.filePath, super.key});

  @override
  State<VideoLiveThumbnail> createState() => _VideoLiveThumbnailState();
}

class _VideoLiveThumbnailState extends State<VideoLiveThumbnail> {
  late WinVideoPlayerController controller;

  @override
  void initState() {
    super.initState();
    controller = WinVideoPlayerController.file(File(widget.filePath));
    log(
      LgLvl.fine,
      'Initializing video live thumbnail  --  ${widget.filePath}',
    );
    controller.videoEventStream.listen((event) {
      log(LgLvl.info, '${event.eventType}  --  ${widget.filePath}');
      switch (event.eventType) {
        case VideoEventType.initialized:
          setState(() {
            controller.seekTo(const Duration(seconds: 60));
          });
        case VideoEventType.completed:
        case VideoEventType.bufferingUpdate:
        case VideoEventType.bufferingStart:
        case VideoEventType.bufferingEnd:
        case VideoEventType.isPlayingStateUpdate:
        case VideoEventType.unknown:
      }
    });
    controller.initialize();
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WinVideoPlayer(controller);
  }
}
