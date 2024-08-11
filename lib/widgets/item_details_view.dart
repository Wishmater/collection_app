import 'dart:math' as math;
import 'package:collection_app/models/item.dart';
import 'package:collection_app/providers/app_state_provider.dart';
import 'package:collection_app/widgets/item_thumbnail/video_cached_thumbnail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:from_zero_ui/from_zero_ui.dart';
import 'package:intl/intl.dart';


class ItemDetailsView extends ConsumerWidget {

  final Item item;
  final bool isMainScrollbar;

  const ItemDetailsView({
    required this.item,
    this.isMainScrollbar = false,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scrollController = ScrollController();
    Widget visualization;
    final dateFormat = DateFormat('yyyy MMMM dd - hh:mm:ss');
    switch(item.itemType!) {
      case ItemType.image:
        visualization = Center(
          child: Text('Visualization widget for images not implemented',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        );
      case ItemType.video:
      // thumbnail = VideoLiveThumbnail(
      //   filePath: widget.item.getAbsoluteFilePath()!,
      // );
        visualization = VideoCachedThumbnail(
          item: item,
        );
      case ItemType.audio:
        visualization = Center(
          child: Text('Visualization widget for audio not implemented',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        );
      case ItemType.unknown:
        visualization = const ErrorSign(title: '');
      case ItemType.album:
      // TODO 1 implement visualization for album
        visualization = Center(
          child: Text('Visualization widget for albums not implemented',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        );
    }
    final filePath = item.getAbsoluteFilePath();
    return ScrollbarFromZero(
      controller: scrollController,
      mainScrollbar: isMainScrollbar,
      child: CustomScrollView(
        controller: scrollController,
        slivers: [
          SliverToBoxAdapter(
            child: AppbarFromZero(
              key: ValueKey(item.name), // fixes weird behaviour in OverflowScroll when switching items
              title: OverflowScroll(
                child: Text(item.name,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              backgroundColor: Theme.of(context).canvasColor.withOpacity(0.7),
              actions: [
                ActionFromZero(
                  title: 'Close details view',
                  icon: const Icon(Icons.close),
                  breakpoints: {0: ActionState.icon},
                  onTap: (context) {
                    ref.read(AppStateProvider.selectedItem.notifier).state = null;
                    ref.read(AppStateProvider.selectedTag.notifier).state = null;
                  },
                ),
              ],
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 8,),),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: AspectRatio(
                aspectRatio: 16/9,
                child: visualization,
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 24,),),

          // priority 1 data
          SliverToBoxAdapter(
            child: DetailsValueWidget(
              title: const Text('Rating'),
              value: Text(item.rating?.toString()??'',
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  fontWeight: FontWeight.w900,
                  color: Color.alphaBlend(Colors.yellow.withOpacity(0.6), Theme.of(context).canvasColor),
                  height: 1.28,
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: DetailsValueWidget(
              title: const Text('Priority'),
              value: Text(item.explorePriority?.toString()??'',
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  fontWeight: FontWeight.w900,
                  color: Color.alphaBlend(Colors.purple.withOpacity(0.8), Theme.of(context).canvasColor),
                  height: 1.28,
                ),
              ),
            ),
          ),
          // TODO 1 we can make a WAY cuter implementation of tags displaying
          SliverToBoxAdapter(
            child: DetailsValueWidget(
              title: const Text('Tags'),
              value: Text(item.tags.map((e) => e.name).reduce((v, e) => '$v, $e')),
            ),
          ),
          if (item.duration!=null)
            SliverToBoxAdapter(
              child: DetailsValueWidget(
                title: const Text('Duration'),
                value: Text(_printDuration(item.duration!)),
              ),
            ),
          if (item.resolutionWidth!=null && item.resolutionHeight!=null)
            SliverToBoxAdapter(
              child: DetailsValueWidget(
                title: const Text('Resolution'),
                value: Text('${item.resolutionWidth} x ${item.resolutionHeight}'),
              ),
            ),

          const SliverToBoxAdapter(child: SizedBox(height: 24,),),

          // priority 2 data
          SliverToBoxAdapter(
            child: DetailsValueWidget(
              title: const Text('Collection'),
              value: Text(item.collection.name),
            ),
          ),
          SliverToBoxAdapter(
            child: DetailsValueWidget(
              title: const Text('Item Added'),
              value: Text(dateFormat.format(item.added)),
            ),
          ),
          if (item.lastModified!=null)
            SliverToBoxAdapter(
              child: DetailsValueWidget(
                title: const Text('Item Modified'),
                value: Text(dateFormat.format(item.lastModified!)),
              ),
            ),
          if (item.lastSeen!=null)
            SliverToBoxAdapter(
              child: DetailsValueWidget(
                title: const Text('Last Seen'),
                value: Text(dateFormat.format(item.lastSeen!)),
              ),
            ),

          const SliverToBoxAdapter(child: SizedBox(height: 24,),),

          // file metadata
          if (item.metadataLastUpdated!=null)
            SliverToBoxAdapter(
              child: DetailsValueWidget(
                title: const Text('Metadata'),
                value: Text(dateFormat.format(item.metadataLastUpdated!)),
              ),
            ),
          if (item.filesize!=null)
            SliverToBoxAdapter(
              child: DetailsValueWidget(
                title: const Text('File Size'),
                value: Text(_getFileSize(item.filesize!)),
              ),
            ),
          if (item.fileCreated!=null)
            SliverToBoxAdapter(
              child: DetailsValueWidget(
                title: const Text('File Created'),
                value: Text(dateFormat.format(item.fileCreated!)),
              ),
            ),
          if (item.fileModified!=null)
            SliverToBoxAdapter(
              child: DetailsValueWidget(
                title: const Text('File Mod.'),
                value: Text(dateFormat.format(item.fileModified!)),
              ),
            ),
          if (filePath!=null)
            SliverToBoxAdapter(
              child: DetailsValueWidget(
                title: const Text('File Path'),
                value: Text(filePath),
              ),
            ),

          const SliverToBoxAdapter(child: SizedBox(height: 48,),),

        ],
      ),
    );
  }

}



class DetailsValueWidget extends StatelessWidget {

  final Widget title;
  final Widget value;

  const DetailsValueWidget({
    required this.title,
    required this.value,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 84,
            child: title,
          ),
          const SizedBox(width: 6,),
          Expanded(
            child: value,
          ),
        ],
      ),
    );
  }

}


String _printDuration(Duration duration) {
  String twoDigits(int n) => n.toString().padLeft(2, "0");
  String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60).abs());
  String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60).abs());
  return "${duration.inHours==0 ? '' : '${twoDigits(duration.inHours)}:'}$twoDigitMinutes:$twoDigitSeconds";
}
String _getFileSize(int bytes, [int decimals = 1]) {
  if (bytes <= 0) return "0 B";
  const suffixes = ["B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"];
  var i = (math.log(bytes) / math.log(1024)).floor();
  return '${(bytes / math.pow(1024, i)).toStringAsFixed(decimals)} ${suffixes[i]}';
}