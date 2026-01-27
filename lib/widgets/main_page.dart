import 'package:collection_app/providers/app_state_provider.dart';
import 'package:collection_app/widgets/filters_widget.dart';
import 'package:collection_app/widgets/item_cards_explorer.dart';
import 'package:collection_app/widgets/item_details_view.dart';
import 'package:collection_app/widgets/item_explorer_appbar.dart';
import 'package:collection_app/widgets/main_appbar.dart';
import 'package:collection_app/widgets/tags_explorer.dart';
import 'package:dartx/dartx_io.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:from_zero_ui/from_zero_ui.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    return ScaffoldFromZero(
      appbarType: AppbarType.none,
      constraintBodyOnXLargeScreens: false,
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Consumer(
            builder: (context, ref, child) {
              double tagsColumnWidth = ref.watch(AppStateProvider.tagsColumnWidth).coerceAtMost(screenWidth / 3);
              return SizedBox(
                width: tagsColumnWidth,
                child: Stack(
                  children: [
                    const Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        MainAppbar(),
                        FiltersWidget(),
                        Expanded(child: TagsExplorerV1()),
                      ],
                    ),
                    Positioned(
                      top: 0,
                      bottom: 0,
                      right: 0,
                      width: 1,
                      child: ColoredBox(color: Theme.of(context).dividerColor),
                    ),
                    Positioned(
                      top: 0,
                      bottom: 0,
                      right: 0,
                      width: 8,
                      child: MouseRegion(
                        cursor: SystemMouseCursors.resizeColumn,
                        hitTestBehavior: HitTestBehavior.translucent,
                        child: GestureDetector(
                          onHorizontalDragUpdate: (details) {
                            if (details.delta.dx != 0) {
                              tagsColumnWidth = (tagsColumnWidth + details.delta.dx).clamp(
                                AppStateProvider.mainPageMinColumnWidth,
                                screenWidth / 3,
                              );
                              ref
                                  .read(
                                    AppStateProvider.tagsColumnWidth.notifier,
                                  )
                                  .setState(tagsColumnWidth);
                            }
                          },
                          onDoubleTap: () {
                            tagsColumnWidth = AppStateProvider.mainPageDefaultTagsColumnWidth.clamp(
                              AppStateProvider.mainPageMinColumnWidth,
                              screenWidth / 3,
                            );
                            ref.read(AppStateProvider.tagsColumnWidth.notifier).setState(tagsColumnWidth);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          Consumer(
            builder: (context, ref, child) {
              double itemsColumnWidth = ref.watch(AppStateProvider.itemsColumnWidth).coerceAtMost(screenWidth / 2);
              final showItemViewInMainPage =
                  ref.watch(AppStateProvider.showItemViewInMainPage) &&
                  ref.watch(
                    AppStateProvider.selectedItem.select((v) => v != null),
                  );
              Widget result = Stack(
                children: [
                  const ItemCardsExplorer(
                    isMainScrollbar: true,
                    // isMainScrollbar: !showItemViewInMainPage,
                  ),
                  const Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: ItemExplorerAppbar(),
                  ),
                  if (showItemViewInMainPage)
                    Positioned(
                      top: 0,
                      bottom: 0,
                      right: 0,
                      width: 1,
                      child: ColoredBox(color: Theme.of(context).dividerColor),
                    ),
                  if (showItemViewInMainPage)
                    Positioned(
                      top: 0,
                      bottom: 0,
                      right: 0,
                      width: 8,
                      child: MouseRegion(
                        cursor: SystemMouseCursors.resizeColumn,
                        hitTestBehavior: HitTestBehavior.translucent,
                        child: GestureDetector(
                          onHorizontalDragUpdate: (details) {
                            if (details.delta.dx != 0) {
                              itemsColumnWidth = (itemsColumnWidth + details.delta.dx).clamp(
                                AppStateProvider.mainPageMinColumnWidth,
                                screenWidth / 2,
                              );
                              ref
                                  .read(
                                    AppStateProvider.itemsColumnWidth.notifier,
                                  )
                                  .setState(itemsColumnWidth);
                            }
                          },
                          onDoubleTap: () {
                            itemsColumnWidth = AppStateProvider.mainPageDefaultItemsColumnWidth.clamp(
                              AppStateProvider.mainPageMinColumnWidth,
                              screenWidth / 2,
                            );
                            ref
                                .read(
                                  AppStateProvider.itemsColumnWidth.notifier,
                                )
                                .setState(itemsColumnWidth);
                          },
                        ),
                      ),
                    ),
                ],
              );
              if (showItemViewInMainPage) {
                result = SizedBox(width: itemsColumnWidth, child: result);
              } else {
                result = Expanded(child: result);
              }
              return result;
            },
          ),
          Consumer(
            builder: (context, ref, child) {
              final showItemViewInMainPage = ref.watch(
                AppStateProvider.showItemViewInMainPage,
              );
              if (!showItemViewInMainPage) {
                return const SizedBox.shrink();
              }
              final selectedItem = ref.watch(AppStateProvider.selectedItem);
              if (selectedItem == null) {
                return const SizedBox.shrink();
              }
              return Expanded(
                child: ItemDetailsView(
                  item: selectedItem,
                  isMainScrollbar: true,
                ),
              );
              // final selectedTag = ref.watch(AppStateProvider.selectedTag);
              // if (selectedTag!=null) {
              //   return Expanded(
              //     child: Text('Selected Tag: $selectedTag'),
              //   );
              // }
              // return const Expanded(child: SizedBox.shrink());
            },
          ),
        ],
      ),
    );
  }
}
