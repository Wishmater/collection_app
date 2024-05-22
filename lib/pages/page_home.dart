import 'dart:io';

import 'package:collection_app/daos/tag.dart';
import 'package:collection_app/models/collection.dart';
import 'package:collection_app/models/item.dart';
import 'package:collection_app/models/tag.dart';
import 'package:collection_app/pages/main_scaffold.dart';
import 'package:collection_app/providers/_isar_provider.dart';
import 'package:collection_app/providers/collection_provider.dart';
import 'package:collection_app/providers/file_provider.dart';
import 'package:collection_app/providers/item_provider.dart';
import 'package:collection_app/widgets/tag_explorer.dart';
import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:from_zero_ui/from_zero_ui.dart';
import 'package:preload_page_view/preload_page_view.dart';


class PageHome extends ConsumerStatefulWidget {

  const PageHome({Key? key}) : super(key: key);

  @override
  PageHomeState createState() => PageHomeState();

}


class PageHomeState extends ConsumerState<PageHome> {

  final ValueNotifier<Tag?> selectedTag = ValueNotifier(null);
  final ValueNotifier<Item?> selectedItem = ValueNotifier(null);

  @override
  Widget build(context) {
    final tabNames = ['Tags', 'Files'];
    final tabPageController = PreloadPageController();
    final tabContentScrollControllers = tabNames.map((e) => ScrollController()).toList();
    final tabBarScrollController = ScrollController();
    // TODO 2 make windowBar only appear on hover (make it an option in ScaffoldFromZero)
    return ScaffoldMain(
      appbarType: AppbarType.none,
      body: ApiProviderBuilder<CollectionData>(
        provider: CollectionProvider.openCollection,
        dataBuilder: (context, collection) {
          print ('BUILD HOME');
          return Row(
            children: [
              SizedBox(
                width: 400,
                child: DefaultTabController(
                  length: tabNames.length,
                  child: Column(
                    children: [
                      ScrollbarFromZero(
                        controller: tabBarScrollController,
                        opacityGradientDirection: OpacityGradient.horizontal,
                        child: Padding(
                          padding: EdgeInsets.only(bottom: PlatformExtended.isDesktop ? 8 : 0,),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            controller: tabBarScrollController,
                            child: IntrinsicWidth(
                              child: Card(
                                clipBehavior: Clip.hardEdge,
                                child: ContextMenuFromZero(
                                  actions: [
                                    ActionFromZero(
                                      title: 'New Tag',
                                      icon: const Icon(Icons.add),
                                      onTap: (context) async {
                                        final model = await TagDAO.buildDao(null, null).maybeEdit(this.context);
                                        if (mounted && model!=null) {
                                          selectedTag.value = model;
                                        }
                                      },
                                    ),
                                  ],
                                  child: TabBar(
                                    isScrollable: true,
                                    indicatorWeight: 3,
                                    tabs: tabNames.mapIndexed((i, e) {
                                      Widget result = Container(
                                        height: 32,
                                        alignment: Alignment.center,
                                        child: Text(e, style: Theme.of(context).textTheme.subtitle1,),
                                      );
                                      return result;
                                    }).toList(),
                                    onTap: (value) {
                                      tabPageController.animateToPage(value,
                                        duration: kTabScrollDuration,
                                        curve: Curves.ease,
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 0,
                        child: TabBarView(
                          children: List.filled(tabNames.length, Container()),
                        ),
                      ),
                      Expanded(
                        child: PreloadPageView(
                          controller: tabPageController,
                          preloadPagesCount: 999,
                          onPageChanged: (value) {
                            DefaultTabController.of(context)?.animateTo(value);
                          },
                          children: tabNames.mapIndexed((i, tabName) {
                            Widget result;
                            if (i==0) {
                              result = TagExplorer(
                                rootTag: null,
                                selectedTag: selectedTag,
                              );
                            } else if (i==1) {
                              result = TagExplorer(
                                rootTag: DirectoryTag(collection.baseDirectory),
                                selectedTag: selectedTag,
                              );
                            } else {
                              throw UnimplementedError();
                            }
                            return ScrollbarFromZero(
                              controller: tabContentScrollControllers[i],
                              child: FocusTraversalGroup(
                                child: SingleChildScrollView(
                                  controller: tabContentScrollControllers[i],
                                  child: Padding(
                                    padding: const EdgeInsets.only(bottom: 28,),
                                    child: result,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: ValueListenableBuilder<Tag?>(
                  valueListenable: selectedTag,
                  builder: (context, selectedTag, child) {
                    if (selectedTag==null) {
                      return Container();
                    } else {
                      return ApiProviderBuilder<List<Item>>(
                        provider: selectedTag is DirectoryTag
                            ? FileProvider.listFiles.call(selectedTag.name)
                            : ItemProvider.withTags.call([selectedTag]),
                        dataBuilder: (context, items) {
                          final gridScrollController = ScrollController();
                          return ScrollbarFromZero(
                            controller: gridScrollController,
                            child: GridView.builder(
                              controller: gridScrollController,
                              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                                maxCrossAxisExtent: 128,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                              ),
                              itemCount: items.length,
                              padding: const EdgeInsets.all(12),
                              itemBuilder: (context, index) {
                                return Stack(
                                  children: [
                                    ValueListenableBuilder(
                                      valueListenable: selectedItem,
                                      builder: (context, selectedItem, child) {
                                        if (selectedItem==items[index]) {
                                          return Container(
                                            color: Theme.of(context).accentColor.withOpacity(0.2),
                                          );
                                        } else {
                                          return const SizedBox.shrink();
                                        }
                                      },
                                    ),
                                    Center(
                                      child: Image.file(File(items[index].filePath),
                                        alignment: Alignment.center,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                    Material(
                                      type: MaterialType.transparency,
                                      child: InkWell(
                                        onTap: () {
                                          selectedItem.value = items[index];
                                        },
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          );
                        },
                      );
                    }
                  },
                ),
              ),
              Expanded(
                child: ValueListenableBuilder<Item?>(
                  valueListenable: selectedItem,
                  builder: (context, selectedItem, child) {
                    if (selectedItem==null) {
                      return Container();
                    } else {
                      return Image.file(File(selectedItem.filePath));
                    }
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

}