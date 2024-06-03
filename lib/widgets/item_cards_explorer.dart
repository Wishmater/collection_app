import 'dart:io';
import 'package:collection_app/providers/app_state_provider.dart';
import 'package:collection_app/widgets/item_thumbnail/video_cached_thumbnail.dart';
import 'package:collection_app/widgets/utils/multi_tap_recognizer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:from_zero_ui/from_zero_ui.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:url_launcher/url_launcher.dart';


class ItemCardsExplorer extends ConsumerWidget {

  static const verticalSpacing = 15.0;
  static const horizontalSpacing = 20.0;

  const ItemCardsExplorer({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scrollController = ScrollController();
    final items = ref.watch(AppStateProvider.itemsWithCurrentFilters);
    return ScrollbarFromZero(
      controller: scrollController,
      child: AlignedGridView.extent(
        controller: scrollController,
        itemCount: items.length,
        maxCrossAxisExtent: 256,
        padding: const EdgeInsets.symmetric(
          horizontal: horizontalSpacing/2,
          vertical: verticalSpacing/2,
        ),
        // crossAxisSpacing: horizontalSpacing,
        // mainAxisSpacing: verticalSpacing,
        itemBuilder: (context, index) {
          final item = items[index];
          Widget thumbnail;
          thumbnail = VideoCachedThumbnail(
            item: item,
          );
          return MultiTapListener(
            onDoubleTap: () {
              final filePath = item.getAbsoluteFilePath();
              ref.read(AppStateProvider.selectedItem.state).state = item;
              ref.read(AppStateProvider.openItem.state).state = item;
              if (!ref.read(AppStateProvider.showItemViewInMainPage)) {
                if (filePath!=null) {
                  launch(filePath);
                }
              }
            },
            child: InkWell(
              borderRadius: const BorderRadius.all(Radius.circular(6)),
              onTap: () {
                ref.read(AppStateProvider.selectedItem.state).state = item;
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: horizontalSpacing/2,
                  vertical: verticalSpacing/2,
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
        },
      ),
    );
  }

}




