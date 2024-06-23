import 'package:flutter/material.dart';


class IntervalRatingBar extends StatelessWidget {

  final int min;
  final int max;
  final int? from;
  final int? to;
  final ValueChanged<int?> onFromChanged;
  final ValueChanged<int?> onToChanged;
  final Color? color;
  final Widget Function(BuildContext context, int value, {required bool selected, Color? color}) widgetBuilder;

  const IntervalRatingBar({
    required this.min,
    required this.max,
    required int? from,
    required int? to,
    required this.onFromChanged,
    required this.onToChanged,
    this.color,
    this.widgetBuilder = IntervalRatingBar.defaultWidgetBuilder,
    super.key,
  })  : from = to==null ? from : (from??min),
        to = from==null ? to : (to??max);

  @override
  Widget build(BuildContext context) {
    final count = max - min + 1;
    return Row(
      children: List.generate(count, (i) {
        final value = i + min;
        final selected = from==null || to==null
            ? false
            : value>=from! && value<=to!;
        bool willMoveFrom;
        if (from==null || to==null) {
          willMoveFrom = true;
        } else {
          final fromDiff = (value-from!).abs();
          final toDiff = (value-to!).abs();
          willMoveFrom = fromDiff<=toDiff;
        }
        return DragTarget<bool>(
          onWillAccept: (data) {
            if (data==null) return false;
            if (from==null || to==null) {
              onFromChanged(value);
              onToChanged(value);
            } else if (value<from!) {
              onFromChanged(value);
            } else if (value>to!) {
              onToChanged(value);
            } else if (data) {
              onFromChanged(value);
            } else {
              onToChanged(value);
            }
            return false;
          },
          builder: (context, candidateData, rejectedData) {
            return Draggable(
              data: willMoveFrom,
              feedback: const SizedBox.shrink(),
              child: InkWell(
                onTap: () {
                  if (from==null || to==null) {
                    onFromChanged(value);
                    onToChanged(value);
                  } else if (value==from && value==to) {
                    onFromChanged(null);
                    onToChanged(null);
                  } else if (value<from!) {
                    onFromChanged(value);
                  } else if (value>to!) {
                    onToChanged(value);
                  } else {
                    if (willMoveFrom) {
                      onFromChanged(value);
                    } else {
                      onToChanged(value);
                    }
                  }
                },
                child: widgetBuilder(context, value,
                  selected: selected,
                  color: color,
                ),
              ),
            );
          },
        );
      }),
    );
  }

  static Widget defaultWidgetBuilder(BuildContext context, int value, {
    required bool selected,
    Color? color,
  }) {
    return Icon(selected ? Icons.star : Icons.star_border,
      color: color ?? Theme.of(context).primaryColor,
    );
  }

}
