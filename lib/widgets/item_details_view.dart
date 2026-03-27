import 'dart:async';
import 'dart:math' as math;
import 'package:collection_app/models/item.dart';
import 'package:collection_app/models/tag.dart';
import 'package:collection_app/providers/app_state_provider.dart';
import 'package:collection_app/providers/item_provider.dart';
import 'package:collection_app/providers/tag_provider.dart';
import 'package:collection_app/util/any_ref.dart';
import 'package:collection_app/widgets/item_thumbnail/video_live_thumbnail.dart';
import 'package:collection_app/widgets/tags_in_item_details.dart';
import 'package:collection_app/widgets/utils/hover_builder.dart';
import 'package:collection_app/widgets/utils/interval_rating_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:from_zero_ui/from_zero_ui.dart';
import 'package:intl/intl.dart';

class ItemDetailsView extends ConsumerStatefulWidget {
  final Item item;
  final bool isMainScrollbar;

  const ItemDetailsView({
    required this.item,
    this.isMainScrollbar = false,
    super.key,
  });

  @override
  ConsumerState<ItemDetailsView> createState() => _ItemDetailsViewState();
}

class _ItemDetailsViewState extends ConsumerState<ItemDetailsView> {
  StreamSubscription<Item>? _itemsUpdateSubscription;

  @override
  void initState() {
    super.initState();
    _itemsUpdateSubscription = ItemProvider.updatedItemIdsStream.listen((
      Item item,
    ) {
      if (item == widget.item) setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    _itemsUpdateSubscription?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final scrollController = ScrollController();
    Widget visualization;
    final dateFormat = DateFormat('yyyy MMMM dd - hh:mm:ss');
    switch (widget.item.itemType!) {
      case ItemType.image:
        visualization = Center(
          child: Text(
            'Visualization widget for images not implemented',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        );
      case ItemType.video:
        final filepath = widget.item.getAbsoluteFilePath()!;
        visualization = VideoLiveThumbnail(
          key: ValueKey(filepath),
          filePath: filepath,
        );
      case ItemType.audio:
        visualization = Center(
          child: Text(
            'Visualization widget for audio not implemented',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        );
      case ItemType.unknown:
        visualization = const ErrorSign(title: '');
      case ItemType.album:
        // TODO: 1 implement visualization for album
        visualization = Center(
          child: Text(
            'Visualization widget for albums not implemented',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        );
    }
    final filePath = widget.item.getAbsoluteFilePath();
    return ScrollbarFromZero(
      controller: scrollController,
      mainScrollbar: widget.isMainScrollbar,
      child: CustomScrollView(
        controller: scrollController,
        slivers: [
          SliverToBoxAdapter(
            child: AppbarFromZero(
              key: ValueKey(
                widget.item.name,
              ), // fixes weird behaviour in OverflowScroll when switching items
              title: OverflowScroll(
                child: Text(
                  widget.item.name,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              backgroundColor: Theme.of(context).canvasColor.withValues(alpha: 0.7),
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
          const SliverToBoxAdapter(child: SizedBox(height: 8)),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: AspectRatio(aspectRatio: 16 / 9, child: visualization),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 24)),

          // priority 1 data
          SliverToBoxAdapter(
            child: DetailsValueWidget(
              title: const Text('Rating'),
              value: const SizedBox(),
              defaultBuilder: (context) {
                return Text(
                  widget.item.rating?.toString() ?? '',
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    fontWeight: FontWeight.w900,
                    color: Color.alphaBlend(
                      Colors.yellow.withValues(alpha: 0.6),
                      Theme.of(context).canvasColor,
                    ),
                    height: 1.28,
                  ),
                );
              },
              hoveredBuilder: (context) {
                final color = Color.alphaBlend(
                  Colors.yellow.withValues(alpha: 0.6),
                  Theme.of(context).canvasColor,
                );
                final textStyle = Theme.of(context).textTheme.titleMedium!;
                return IntervalRatingBar(
                  min: 1,
                  max: 10,
                  color: color,
                  from: widget.item.rating,
                  to: widget.item.rating,
                  onFromChanged: (value) {
                    if (widget.item.rating == value) return;
                    widget.item.rating = value;
                    ItemProvider.saveItem(
                      AnyRef(widgetRef: ref),
                      widget.item,
                    );
                  },
                  onToChanged: (value) {
                    if (widget.item.rating == value) return;
                    widget.item.rating = value;
                    ItemProvider.saveItem(
                      AnyRef(widgetRef: ref),
                      widget.item,
                    );
                  },
                  widgetBuilder: (context, value, {required selected, color}) {
                    return Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Positioned(
                          left: 0,
                          right: 0,
                          top: -2,
                          bottom: -2,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 100),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: selected
                                  ? color!.withValues(
                                      alpha: color.a * 0.6,
                                    )
                                  : null,
                              borderRadius: BorderRadius.horizontal(
                                left: widget.item.rating == value ? const Radius.circular(6) : Radius.zero,
                                right: widget.item.rating == value ? const Radius.circular(6) : Radius.zero,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: value == 10 ? 24 : 18,
                          alignment: Alignment.center,
                          child: Text(
                            value.toString(),
                            style: textStyle.copyWith(
                              fontWeight: FontWeight.w900,
                              height: 1.28,
                              color: selected ? textStyle.color!.withValues(alpha: 0.8) : color,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
          SliverToBoxAdapter(
            child: DetailsValueWidget(
              title: const Text('Priority'),
              value: const SizedBox(),
              defaultBuilder: (context) {
                return Text(
                  widget.item.explorePriority?.toString() ?? '',
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    fontWeight: FontWeight.w900,
                    color: Color.alphaBlend(
                      Colors.purple.withValues(alpha: 0.8),
                      Theme.of(context).canvasColor,
                    ),
                    height: 1.28,
                  ),
                );
              },
              hoveredBuilder: (context) {
                final color = Color.alphaBlend(
                  Colors.purple.withValues(alpha: 0.8),
                  Theme.of(context).canvasColor,
                );
                final textStyle = Theme.of(context).textTheme.titleMedium!;
                return IntervalRatingBar(
                  min: -6,
                  max: 3,
                  color: color,
                  from: widget.item.explorePriority,
                  to: widget.item.explorePriority,
                  onFromChanged: (value) {
                    if (widget.item.explorePriority == value) return;
                    widget.item.explorePriority = value;
                    ItemProvider.saveItem(
                      AnyRef(widgetRef: ref),
                      widget.item,
                    );
                  },
                  onToChanged: (value) {
                    if (widget.item.explorePriority == value) return;
                    widget.item.explorePriority = value;
                    ItemProvider.saveItem(
                      AnyRef(widgetRef: ref),
                      widget.item,
                    );
                  },
                  widgetBuilder: (context, value, {required selected, color}) {
                    Widget result = Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Positioned(
                          left: 0,
                          right: 0,
                          top: -2,
                          bottom: -2,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 100),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: selected
                                  ? color!.withValues(
                                      alpha: color.a * 0.6,
                                    )
                                  : null,
                              borderRadius: BorderRadius.horizontal(
                                left: widget.item.explorePriority == value ? const Radius.circular(6) : Radius.zero,
                                right: widget.item.explorePriority == value ? const Radius.circular(6) : Radius.zero,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: 18,
                          alignment: Alignment.center,
                          child: Stack(
                            children: [
                              Text(
                                value.abs().toString(),
                                style: textStyle.copyWith(
                                  fontWeight: FontWeight.w900,
                                  height: 1.28,
                                  color: selected ? textStyle.color!.withValues(alpha: 0.8) : color,
                                ),
                              ),
                              if (value < 0)
                                Positioned(
                                  bottom: 1,
                                  left: -1,
                                  right: -1,
                                  height: 3,
                                  child: ColoredBox(
                                    color: selected
                                        ? textStyle.color!.withValues(
                                            alpha: 0.6,
                                          )
                                        : color!.withValues(
                                            alpha: color.a * 0.8,
                                          ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    );
                    if (value == -1) {
                      result = Row(
                        children: [
                          result,
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 4,
                              right: 1,
                            ),
                            child: Container(
                              width: 5,
                              height: 3,
                              color: Theme.of(context).dividerColor,
                            ),
                          ),
                        ],
                      );
                    }
                    return result;
                  },
                );
              },
            ),
          ),
          SliverToBoxAdapter(
            child: DetailsValueWidget(
              title: const Text('Tags'),
              value: const SizedBox(),
              defaultBuilder: (context) {
                return Wrap(
                  spacing: 4,
                  runSpacing: 4,
                  children: widget.item.tags.map((tag) {
                    return TagChip(
                      tag: tag,
                      onRemove: () {
                        ItemProvider.removeTagFromItem(
                          AnyRef(widgetRef: ref),
                          widget.item,
                          tag,
                        );
                      },
                    );
                  }).toList(),
                );
              },
              hoveredBuilder: (context) {
                return Wrap(
                  spacing: 4,
                  runSpacing: 4,
                  children: [
                    ...widget.item.tags.map((tag) {
                      return TagChip(
                        tag: tag,
                        onRemove: () {
                          ItemProvider.removeTagFromItem(
                            AnyRef(widgetRef: ref),
                            widget.item,
                            tag,
                          );
                        },
                      );
                    }),
                    AddTagButton(
                      onTagSelected: (tag) {
                        ItemProvider.addTagToItem(
                          AnyRef(widgetRef: ref),
                          widget.item,
                          tag,
                        );
                      },
                      onTagCreated: (name) {
                        final newTag = Tag(name: name);
                        TagProvider.addTag(ref, newTag, widget.item.collection);
                        ItemProvider.addTagToItem(
                          AnyRef(widgetRef: ref),
                          widget.item,
                          newTag,
                        );
                      },
                      excludedTags: widget.item.tags,
                    ),
                  ],
                );
              },
            ),
          ),
          if (widget.item.duration != null)
            SliverToBoxAdapter(
              child: DetailsValueWidget(
                title: const Text('Duration'),
                value: Text(_printDuration(widget.item.duration!)),
              ),
            ),
          if (widget.item.resolutionWidth != null && widget.item.resolutionHeight != null)
            SliverToBoxAdapter(
              child: DetailsValueWidget(
                title: const Text('Resolution'),
                value: Text(
                  '${widget.item.resolutionWidth} x ${widget.item.resolutionHeight}',
                ),
              ),
            ),

          const SliverToBoxAdapter(child: SizedBox(height: 24)),

          // priority 2 data
          SliverToBoxAdapter(
            child: DetailsValueWidget(
              title: const Text('Collection'),
              value: Text(widget.item.collection.name),
            ),
          ),
          SliverToBoxAdapter(
            child: DetailsValueWidget(
              title: const Text('Item Added'),
              value: Text(dateFormat.format(widget.item.added)),
            ),
          ),
          if (widget.item.lastModified != null)
            SliverToBoxAdapter(
              child: DetailsValueWidget(
                title: const Text('Item Modified'),
                value: Text(dateFormat.format(widget.item.lastModified!)),
              ),
            ),
          if (widget.item.lastSeen != null)
            SliverToBoxAdapter(
              child: DetailsValueWidget(
                title: const Text('Last Seen'),
                value: Text(dateFormat.format(widget.item.lastSeen!)),
              ),
            ),

          const SliverToBoxAdapter(child: SizedBox(height: 24)),

          // file metadata
          if (widget.item.metadataLastUpdated != null)
            SliverToBoxAdapter(
              child: DetailsValueWidget(
                title: const Text('Metadata'),
                value: Text(
                  dateFormat.format(widget.item.metadataLastUpdated!),
                ),
              ),
            ),
          if (widget.item.filesize != null)
            SliverToBoxAdapter(
              child: DetailsValueWidget(
                title: const Text('File Size'),
                value: Text(_getFileSize(widget.item.filesize!)),
              ),
            ),
          if (widget.item.fileCreated != null)
            SliverToBoxAdapter(
              child: DetailsValueWidget(
                title: const Text('File Created'),
                value: Text(dateFormat.format(widget.item.fileCreated!)),
              ),
            ),
          if (widget.item.fileModified != null)
            SliverToBoxAdapter(
              child: DetailsValueWidget(
                title: const Text('File Mod.'),
                value: Text(dateFormat.format(widget.item.fileModified!)),
              ),
            ),
          if (filePath != null)
            SliverToBoxAdapter(
              child: DetailsValueWidget(
                title: const Text('File Path'),
                value: Text(filePath),
              ),
            ),

          const SliverToBoxAdapter(child: SizedBox(height: 48)),
        ],
      ),
    );
  }
}

class DetailsValueWidget extends StatelessWidget {
  final Widget title;
  final Widget value;
  final WidgetBuilder? defaultBuilder;
  final WidgetBuilder? hoveredBuilder;

  const DetailsValueWidget({
    required this.title,
    required this.value,
    this.defaultBuilder,
    this.hoveredBuilder,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (defaultBuilder != null && hoveredBuilder != null) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        child: HoverBuilder(
          layoutBuilder: (Widget? currentChild, List<Widget> previousChildren) {
            return Stack(
              alignment: Alignment.centerLeft,
              children: <Widget>[
                if (previousChildren.isNotEmpty) previousChildren.last,
                if (currentChild != null) currentChild,
              ],
            );
          },
          defaultBuilder: (context) => Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(width: 84, child: title),
              const SizedBox(width: 6),
              Expanded(child: defaultBuilder!(context)),
            ],
          ),
          hoveredBuilder: (context) => Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(width: 84, child: title),
              const SizedBox(width: 6),
              Expanded(child: hoveredBuilder!(context)),
            ],
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 84, child: title),
          const SizedBox(width: 6),
          Expanded(child: value),
        ],
      ),
    );
  }
}

String _printDuration(Duration duration) {
  String twoDigits(int n) => n.toString().padLeft(2, "0");
  String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60).abs());
  String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60).abs());
  return "${duration.inHours == 0 ? '' : '${twoDigits(duration.inHours)}:'}$twoDigitMinutes:$twoDigitSeconds";
}

String _getFileSize(int bytes, [int decimals = 1]) {
  if (bytes <= 0) return "0 B";
  const suffixes = ["B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"];
  var i = (math.log(bytes) / math.log(1024)).floor();
  return '${(bytes / math.pow(1024, i)).toStringAsFixed(decimals)} ${suffixes[i]}';
}
