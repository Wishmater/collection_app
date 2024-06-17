import 'package:collection_app/util/database.dart';
import 'package:flutter/material.dart';
import 'package:from_zero_ui/from_zero_ui.dart';
import 'package:multi_value_listenable_builder/multi_value_listenable_builder.dart';


class DbProcessIndicatorOverlay extends StatelessWidget {

  final Widget child;

  const DbProcessIndicatorOverlay({
    required this.child,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        Positioned(
          bottom: 8, right: 8,
          child: ValueListenableBuilder(
            valueListenable: DbHelper.activeDbOperationsCount,
            builder: (context, value, child) {
              if (value==0) {
                return const SizedBox.shrink();
              }
              return Material(
                type: MaterialType.transparency,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    const SizedBox(
                      width: 16, height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 4,
                      ),
                    ),
                    Text('$value',
                      style: Theme.of(context).textTheme.labelSmall!.copyWith(
                        fontWeight: FontWeight.w100,
                        color: Theme.of(context).textTheme.labelSmall!.color!.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

}
