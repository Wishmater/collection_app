import 'package:collection_app/pages/main_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:from_zero_ui/from_zero_ui.dart';


class PageItem extends ConsumerStatefulWidget {

  const PageItem({Key? key}) : super(key: key);

  @override
  PageItemState createState() => PageItemState();

}


class PageItemState extends ConsumerState<PageItem> {

  @override
  Widget build(context) {
    final scrollController = ScrollController();
    return ScaffoldMain(
      title: const Text("Item"),
      scrollController: scrollController,
      body: Container(),
    );
  }

}