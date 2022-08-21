import 'dart:io';
import 'package:collection_app/models/tag.dart';
import 'package:collection_app/providers/file_provider.dart';
import 'package:collection_app/providers/tag_provider.dart';
import 'package:flutter/material.dart';
import 'package:from_zero_ui/from_zero_ui.dart';
import 'package:path/path.dart' as path;
import 'package:url_launcher/url_launcher.dart';


class TagExplorer extends StatelessWidget {

  final Tag rootTag;
  final ValueNotifier<Tag?> selectedTag;
  final int indentCount;

  const TagExplorer({
    Key? key,
    required this.rootTag,
    required this.selectedTag,
    this.indentCount = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ApiProviderBuilder<List<Tag>>(
      transitionDuration: Duration.zero,
      provider: rootTag is DirectoryTag
          ? FileProvider.listDirectories.call(rootTag.name)
          : TagProvider.children.call(rootTag.id),
      // applyAnimatedContainerFromChildSize: true,
      dataBuilder: (context, childrenTags) {
        return Column(
          children: childrenTags.map((e) {
            return TagExplorerItem(
              tag: e,
              selectedTag: selectedTag,
              indentCount: indentCount,
            );
          }).toList(),
        );
      },
      loadingBuilder: (context, progress) {
        return const SizedBox(
          height: 6,
          child: LinearProgressIndicator(minHeight: 6),
        );
      },
    );
  }

}


class TagExplorerItem extends StatelessWidget {

  static const childrenSeparation = 20.0;

  final Tag tag;
  final ValueNotifier<Tag?> selectedTag;
  final int indentCount;

  const TagExplorerItem({
    Key? key,
    required this.tag,
    required this.selectedTag,
    this.indentCount = 0,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return ApiProviderBuilder<bool>(
      provider: tag is DirectoryTag
          ? FileProvider.hasChildren.call(tag.name)
          : TagProvider.hasChildren.call(tag.id),
      dataBuilder: (context, hasChildren) {
        return _build(context, hasChildren: hasChildren);
      },
      loadingBuilder: (context, progress) {
        return _build(context);
      },
    );
  }

  Widget _build(BuildContext context, {
    bool hasChildren = true,
  }) {
    return ExpansionTileFromZero(
      actionPadding: EdgeInsets.only(left: 10 + childrenSeparation * indentCount),
      expandedAlignment: Alignment.topCenter,
      title: ValueListenableBuilder(
        valueListenable: selectedTag,
        builder: (context, selectedTag, child) {
          // TODO 3 prevent animation when selecting button from repeating
          return DrawerMenuButtonFromZero(
            contentPadding: EdgeInsets.only(left: childrenSeparation * indentCount),
            selected: selectedTag==tag,
            title: tag is DirectoryTag
                ? path.basename(tag.name)
                : tag.name,
          );
        },
      ),
      contextMenuActions: [
        if (tag is DirectoryTag)
          ActionFromZero(
            title: 'Open in File Explorer',
            icon: const Icon(Icons.window_sharp), // TODO 1 find the fucking popup icon
            onTap: (context) {
              launchUrl(Uri.file(tag.name, windows: Platform.isWindows));
            },
          ),
      ],
      onExpansionChanged: (expanding) {
        if (selectedTag.value==tag) {
          return true;
        } else {
          selectedTag.value = tag;
          return false;
        }
      },
      children: [
        if (hasChildren)
          TagExplorer(
            rootTag: tag,
            selectedTag: selectedTag,
            indentCount: indentCount+1,
          ),
      ],
    );
  }

}
