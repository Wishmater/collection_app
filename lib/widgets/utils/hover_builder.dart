import 'package:flutter/material.dart';

class HoverBuilder extends StatefulWidget {
  final WidgetBuilder defaultBuilder;
  final WidgetBuilder hoveredBuilder;

  // AnimatedSwitcher params
  final Duration duration;
  final Duration? reverseDuration;
  final Curve switchInCurve;
  final Curve switchOutCurve;
  final AnimatedSwitcherTransitionBuilder transitionBuilder;
  final AnimatedSwitcherLayoutBuilder layoutBuilder;

  const HoverBuilder({
    required this.defaultBuilder,
    required this.hoveredBuilder,
    this.duration = const Duration(milliseconds: 150),
    this.reverseDuration,
    this.switchInCurve = Curves.easeOutCubic,
    this.switchOutCurve = Curves.easeInCubic,
    this.transitionBuilder = AnimatedSwitcher.defaultTransitionBuilder,
    this.layoutBuilder = AnimatedSwitcher.defaultLayoutBuilder,
    super.key,
  });

  @override
  State<HoverBuilder> createState() => _HoverBuilderState();
}

class _HoverBuilderState extends State<HoverBuilder> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      hitTestBehavior: HitTestBehavior.translucent,
      onEnter: (event) {
        if (isHovered) return;
        setState(() {
          isHovered = true;
        });
      },
      onExit: (event) {
        if (!isHovered) return;
        setState(() {
          isHovered = false;
        });
      },
      child: AnimatedSwitcher(
        duration: widget.duration,
        reverseDuration: widget.reverseDuration,
        switchInCurve: widget.switchInCurve,
        switchOutCurve: widget.switchOutCurve,
        transitionBuilder: widget.transitionBuilder,
        layoutBuilder: widget.layoutBuilder,
        child: isHovered ? widget.hoveredBuilder(context) : widget.defaultBuilder(context),
      ),
    );
  }
}
