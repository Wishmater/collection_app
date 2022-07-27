import 'package:collection_app/pages/main_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:from_zero_ui/from_zero_ui.dart';


class PageHome extends ConsumerStatefulWidget {

  const PageHome({Key? key}) : super(key: key);

  @override
  PageHomeState createState() => PageHomeState();

}


class PageHomeState extends ConsumerState<PageHome> {

  @override
  Widget build(context) {
    final scrollController = ScrollController();
    return ScaffoldMain(
      title: const Text("Collections"),
      scrollController: scrollController,
      body: Container(),
    );
  }

}