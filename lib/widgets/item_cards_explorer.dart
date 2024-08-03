import 'dart:async';
import 'dart:io';
import 'package:collection_app/models/item.dart';
import 'package:collection_app/providers/app_state_provider.dart';
import 'package:collection_app/providers/item_provider.dart';
import 'package:collection_app/widgets/item_explorer_appbar.dart';
import 'package:collection_app/widgets/item_thumbnail/video_cached_thumbnail.dart';
import 'package:collection_app/widgets/utils/multi_tap_recognizer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:from_zero_ui/from_zero_ui.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:intl/intl.dart';
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
    return Stack(
      children: [
        ScrollbarFromZero(
          controller: scrollController,
          mainScrollbar: isMainScrollbar,
          child: AlignedGridView.extent(
            controller: scrollController,
            itemCount: items.length,
            maxCrossAxisExtent: 256,
            padding: const EdgeInsets.only(
              left: horizontalSpacing/2, right: horizontalSpacing/2,
              bottom: verticalSpacing/2,
              top: verticalSpacing/2 + ItemExplorerAppbar.toolbarHeight,
            ),
            // crossAxisSpacing: horizontalSpacing,
            // mainAxisSpacing: verticalSpacing,
            itemBuilder: (context, index) {
              final item = items[index];
              return ItemCardsWidget(item: item);
            },
          ),
        ),
      ],
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

  late final StreamSubscription<Item> itemsUpdateSubscription;

  @override
  void initState() {
    super.initState();
    ItemProvider.updatedItemIdsStream.listen((Item item) {
      if (item==widget.item) setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    itemsUpdateSubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    Widget thumbnail;
    thumbnail = VideoCachedThumbnail(
      item: widget.item,
    );
    return ContextMenuFromZero(
      actions: [
        ActionFromZero(
          title: 'Open',
          icon: const Icon(Icons.file_open),
          onTap: (context) {
            final filePath = widget.item.getAbsoluteFilePath();
            if (filePath!=null) {
              launch(filePath);
            }
          },
        ),
        ActionFromZero(
          title: 'Open in explorer',
          icon: const Icon(Icons.folder),
          onTap: (context) {
            final filePath = widget.item.getAbsoluteFilePath();
            if (filePath!=null) {
              launch(File(filePath).parent.absolute.path);
            }
          },
        ),
      ],
      child: MultiTapListener(
        onDoubleTap: () {
          final filePath = widget.item.getAbsoluteFilePath();
          if (!ref.read(AppStateProvider.showItemViewInMainPage)) {
            if (filePath!=null) {
              launch(filePath);
            }
          }
        },
        child: InkWell(
          borderRadius: const BorderRadius.all(Radius.circular(6)),
          onTap: () {
            ref.read(AppStateProvider.selectedItem.state).state = widget.item;
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: ItemCardsExplorer.horizontalSpacing/2,
              vertical: ItemCardsExplorer.verticalSpacing/2,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AspectRatio(
                  aspectRatio: 16/9,
                  child: thumbnail,
                ),
                Text(widget.item.name),
                // TODO 1 show tags
                // TODO 1 show explore priority
                // TODO 1 show rating
              ],
            ),
          ),
        ),
      ),
    );
  }

}
