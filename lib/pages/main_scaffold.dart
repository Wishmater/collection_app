import 'package:flutter/material.dart';
import 'package:from_zero_ui/from_zero_ui.dart';

class ScaffoldMain extends StatelessWidget{

  final Widget? title;
  final Widget body;
  final ScrollController? scrollController;
  final List<Widget> actions;
  final bool constraintBodyOnXLargeScreens;
  final int appbarType;

  const ScaffoldMain({
    Key? key,
    required this.body,
    this.title,
    this.scrollController,
    this.actions = const[],
    this.constraintBodyOnXLargeScreens = false,
    this.appbarType = ScaffoldFromZero.appbarTypeQuickReturn,
  })  : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScaffoldFromZero(
      constraintBodyOnXLargeScreens: constraintBodyOnXLargeScreens,
      title: title,
      actions: actions,
      body: body,
      mainScrollController: scrollController,
      appbarType: appbarType,
//      collapsibleBackgroundLength: 56*2.0,
//      collapsibleBackgroundColor: Theme.of(context).secondaryHeaderColor,
//      appbarElevation: 0,
    );
  }

}