import 'package:collection_app/providers/app_state_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:from_zero_ui/from_zero_ui.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:url_launcher/url_launcher.dart';


class ItemCardsExplorer extends ConsumerWidget {

  static const spacing = 24.0;

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
        padding: const EdgeInsets.all(spacing),
        maxCrossAxisExtent: 256,
        crossAxisSpacing: spacing,
        mainAxisSpacing: spacing,
        itemBuilder: (context, index) {
          final item = items[index];
          return InkWell(
            onTap: () {
              ref.read(AppStateProvider.selectedItem.state).state = item;
            },
            onDoubleTap: () {
              ref.read(AppStateProvider.selectedItem.state).state = item;
              ref.read(AppStateProvider.openItem.state).state = item;
              if (!ref.read(AppStateProvider.showItemViewInMainPage)) {
                final filePath = item.getAbsoluteFilePathForItem();
                if (filePath!=null) {
                  launch(filePath);
                }
              }
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AspectRatio(
                  aspectRatio: 16/9,
                  child: Placeholder(), // TODO 1 show video preview
                ),
                Text(item.name),
                // TODO 1 show tags
                // TODO 1 show explore priority
                // TODO 1 show rating
              ],
            ),
          );
        },
      ),
    );
  }

}



class VideoThumbnail extends StatefulWidget {

  const VideoThumbnail({
    super.key,
  });

  @override
  State<VideoThumbnail> createState() => _VideoThumbnailState();

}

class _VideoThumbnailState extends State<VideoThumbnail> {

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }

}
