import 'package:flutter/material.dart';
import 'package:from_zero_ui/from_zero_ui.dart';

class ScaffoldMain extends StatelessWidget{

  final Widget title;
  final Widget body;
  final ScrollController? scrollController;
  final List<Widget> actions;
  final bool constraintBodyOnXLargeScreens;

  const ScaffoldMain({
    Key? key,
    required this.title,
    required this.body,
    this.scrollController,
    this.actions = const[],
    this.constraintBodyOnXLargeScreens = false,
  })  : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScaffoldFromZero(
      constraintBodyOnXLargeScreens: constraintBodyOnXLargeScreens,
      title: title,
      actions: actions,
      body: body,
      mainScrollController: scrollController,
      appbarType: ScaffoldFromZero.appbarTypeQuickReturn,
//      collapsibleBackgroundLength: 56*2.0,
//      collapsibleBackgroundColor: Theme.of(context).secondaryHeaderColor,
//      appbarElevation: 0,
    );
  }

}