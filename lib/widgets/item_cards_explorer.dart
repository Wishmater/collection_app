import 'dart:async';
import 'dart:io';
import 'package:collection_app/models/item.dart';
import 'package:collection_app/providers/app_state_provider.dart';
import 'package:collection_app/providers/data_provider.dart';
import 'package:collection_app/providers/item_provider.dart';
import 'package:collection_app/widgets/item_explorer_appbar.dart';
import 'package:collection_app/widgets/item_thumbnail/video_cached_thumbnail.dart';
import 'package:collection_app/widgets/item_thumbnail/video_live_thumbnail.dart';
import 'package:collection_app/widgets/utils/multi_tap_recognizer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:from_zero_ui/from_zero_ui.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:intl/intl.dart';
import 'package:mlog/mlog.dart';
import 'package:url_launcher/url_launcher.dart';


class ItemCardsExplorer extends ConsumerWidget {

  static const verticalSpacing = 15.0;
  static const horizontalSpacing = 20.0;
  final bool isMainScrollbar;

  const ItemCardsExplorer({
    this.isMainScrollbar = false,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scrollController = ScrollController();
    final items = ref.watch(AppStateProvider.itemsWithCurrentFilters);
    return ScrollbarFromZero(
      controller: scrollController,
      mainScrollbar: isMainScrollbar,
      child: AlignedGridView.extent(
        controller: scrollController,
        itemCount: items.length,
        maxCrossAxisExtent: 256,
        padding: const EdgeInsets.only(
          left: horizontalSpacing/2, right: horizontalSpacing/2,
          bottom: verticalSpacing/2,
          top: verticalSpacing/2 + ItemExplorerAppbar.toolbarHeight - 4,
        ),
        // crossAxisSpacing: horizontalSpacing,
        // mainAxisSpacing: verticalSpacing,
        itemBuilder: (context, index) {
          final item = items[index];
          return ItemCardsWidget(item: item);
        },
      ),
    );
  }

}



class ItemCardsWidget extends ConsumerStatefulWidget {

  final Item item;

  const ItemCardsWidget({
    required this.item,
    super.key,
  });

  @override
  ConsumerState<ItemCardsWidget> createState() => _ItemCardsWidgetState();

}
class _ItemCardsWidgetState extends ConsumerState<ItemCardsWidget> {

  StreamSubscription<Item>? _itemsUpdateSubscription;

  @override
  void initState() {
    super.initState();
    _itemsUpdateSubscription = ItemProvider.updatedItemIdsStream.listen((Item item) {
      if (item==widget.item) setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    _itemsUpdateSubscription?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.item.hasMetadata) {
      return ApiProviderBuilder(
        provider: DataProvider.metadata.call(widget.item),
        animatedSwitcherType: AnimatedSwitcherType.normal,
        dataBuilder: buildContent,
      );
    }
    return buildContent(context, widget.item);
  }

  Widget buildContent(BuildContext context, Item item) {
    Widget thumbnail;
    switch(item.itemType!) {
      case ItemType.image:
        thumbnail = Center(
          child: Text('Thumbnail widget for images not implemented',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        );
      case ItemType.video:
        // thumbnail = VideoLiveThumbnail(
        //   filePath: widget.item.getAbsoluteFilePath()!,
        // );
        thumbnail = VideoCachedThumbnail(
          item: item,
        );
      case ItemType.audio:
        thumbnail = Center(
          child: Text('Thumbnail widget for audio not implemented',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        );
      case ItemType.unknown:
        thumbnail = const ErrorSign(title: '');
    }
    if (item.duration!=null) {
      thumbnail = Stack(
        children: [
          thumbnail,
          Positioned(
            bottom: -0.5, // fixes an ugly rendering bug on windows
            right: 0,
            child: Container(
              padding: const EdgeInsets.only(left: 5, right: 2.5, top: 2, bottom: 1.5),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(4)),
                color: Theme.of(context).canvasColor.withOpacity(0.6),
              ),
              child: Text(_printDuration(item.duration!),
                style: Theme.of(context).textTheme.labelMedium,
              ),
            ),
          ),
        ],
      );
    }
    final isSelected = ref.watch(AppStateProvider.selectedItem.select((v) => v==item));
    Widget result = MultiTapListener(
      onDoubleTap: () {
        final filePath = item.getAbsoluteFilePath();
        if (filePath!=null) {
          launch(filePath);
        }
      },
      child: InkWell(
        borderRadius: const BorderRadius.all(Radius.circular(6)),
        onTap: () {
          ref.read(AppStateProvider.selectedItem.state).state = item;
        },
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: ItemCardsExplorer.horizontalSpacing/2,
            vertical: ItemCardsExplorer.verticalSpacing/2,
          ),
          decoration: !isSelected ? null : BoxDecoration(
            color: Colors.blueAccent.withOpacity(0.2),
            borderRadius: const BorderRadius.all(Radius.circular(6)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AspectRatio(
                aspectRatio: 16/9,
                child: thumbnail,
              ),
              Text(item.name),
              // TODO 1 show tags
              // TODO 1 show explore priority
              // TODO 1 show rating
            ],
          ),
        ),
      ),
    );
    return ContextMenuFromZero(
      actions: [
        ActionFromZero(
          title: 'Open',
          icon: const Icon(Icons.file_open),
          onTap: (context) {
            final filePath = item.getAbsoluteFilePath();
            if (filePath!=null) {
              launch(filePath);
            }
          },
        ),
        ActionFromZero(
          title: 'Open in explorer',
          icon: const Icon(Icons.folder),
          onTap: (context) {
            final filePath = item.getAbsoluteFilePath();
            if (filePath!=null) {
              launch(File(filePath).parent.absolute.path);
            }
          },
        ),
      ],
      child: result,
    );
  }

}


String _printDuration(Duration duration) {
  String twoDigits(int n) => n.toString().padLeft(2, "0");
  String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60).abs());
  String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60).abs());
  return "${duration.inHours==0 ? '' : '${twoDigits(duration.inHours)}:'}$twoDigitMinutes:$twoDigitSeconds";
}