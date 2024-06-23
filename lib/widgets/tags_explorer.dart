import 'package:collection_app/models/tag.dart';
import 'package:collection_app/providers/app_state_provider.dart';
import 'package:collection_app/providers/tag_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:from_zero_ui/from_zero_ui.dart';


class TagsExplorerV1 extends ConsumerWidget {

  const TagsExplorerV1({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO 2 performance this probably needs to be done with slivers in order to be performant
    final rootTags = ref.watch(TagProvider.roots);
    final scrollController = ScrollController();
    return ScrollbarFromZero(
      controller: scrollController,
      child: SingleChildScrollView(
        controller: scrollController,
        child: Column(
          children: [
            for (final e in rootTags)
              TabExplorerItem(tag: e,),
          ],
        ),
      ),
    );
  }

}



class TabExplorerItem extends ConsumerWidget {

  static const childrenSeparation = 20.0;

  final Tag tag;
  final int indentCount;

  const TabExplorerItem({
    required this.tag,
    this.indentCount = 0,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO 1 we need a good way to listen changes in the tag without having to have the provider rebuild
    return ExpansionTileFromZero(
      actionPadding: EdgeInsets.only(left: 10 + childrenSeparation * indentCount),
      expandedAlignment: Alignment.topCenter,
      title: Consumer(
        builder: (context, ref, child) {
          // TODO 3 prevent animation when selecting button from repeating
          final selectedTag = ref.watch(AppStateProvider.selectedTag);
          // TODO 1 show secondary parent tags
          return DrawerMenuButtonFromZero(
            contentPadding: EdgeInsets.only(left: childrenSeparation * indentCount),
            selected: selectedTag==tag,
            title: tag.name,
          );
        },
      ),
      contextMenuActions: [
        // TODO 1 make this remove the tag
        ActionFromZero(
          title: 'Filter including tag',
          icon: const Icon(Icons.filter_alt_outlined),
          onTap: (context) {
            final notifier = ref.read(AppStateProvider.filterIncludingTags.notifier);
            if (!notifier.state.contains(tag)) {
              notifier.state = [...notifier.state, tag];
            }
          },
        ),
        ActionFromZero(
          title: 'Filter excluding tag',
          icon: const Icon(Icons.filter_alt_off_outlined),
          onTap: (context) {
            final notifier = ref.read(AppStateProvider.filterExcludingTags.notifier);
            if (!notifier.state.contains(tag)) {
              notifier.state = [...notifier.state, tag];
            }
          },
        ),
        //   ActionFromZero(
        //     title: 'New Child Tag',
        //     icon: const Icon(Icons.add),
        //     onTap: (context) async {
        //       final model = await TagDAO.buildDao(null, tag).maybeEdit(ref as BuildContext);
        //       if (model!=null) {
        //         selectedTag.value = model;
        //       }
        //     },
        //   ),
        // ActionFromZero(
        //   title: 'Edit Tag',
        //   icon: const Icon(Icons.edit),
        //   onTap: (context) async {
        //     tag.parentTag.loadSync(); // this is not the best practice, but oh well
        //     final model = await TagDAO.buildDao(tag, tag.parentTag.value).maybeEdit(ref as BuildContext);
        //     if (model!=null) {
        //       selectedTag.value = model;
        //     }
        //   },
        // ),
        // ActionFromZero(
        //   title: 'Delete Tag',
        //   icon: const Icon(Icons.delete_forever),
        //   onTap: (context) async {
        //     final result = await TagDAO.buildDao(tag, tag.parentTag.value).maybeDelete(ref as BuildContext);
        //     if (result && selectedTag.value?.id==tag.id) {
        //       selectedTag.value = null;
        //     }
        //   },
        // ),
      ],
      onExpansionChanged: (expanding) {
        final selectedTagState = ref.read(AppStateProvider.selectedTag.state);
        if (selectedTagState.state==tag) {
          return true;
        } else {
          selectedTagState.state = tag;
          return false;
        }
      },
      children: [
        for (final e in tag.childTags)
          TabExplorerItem(
            tag: e,
            indentCount: indentCount+1,
          ),
      ],
    );
  }
}