import 'package:animations/animations.dart';
import 'package:collection_app/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:from_zero_ui/from_zero_ui.dart';


class PageSplash extends ConsumerStatefulWidget {

  const PageSplash({super.key});

  @override
  PageSplashState createState() => PageSplashState();

}

class PageSplashState extends ConsumerState<PageSplash> {

  @override
  void initState() {
    super.initState();
    // DO INITIALIZATION LOGIC HERE (READING FROM DB, ETC)
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      RouteMain().go(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Widget result = IntrinsicWidth(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text("Initializing...",
            style: TextStyle(fontSize: 18),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 6,),
          Container(
            width: 256,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(32)),
            ),
            clipBehavior: Clip.antiAlias,
            child: LinearProgressIndicator(color: theme.colorScheme.primary,),
          ),
        ],
      ),
    );

    final scrollController = ScrollController();
    return ScaffoldFromZero(
      mainScrollController: scrollController,
      appbarType: AppbarType.none,
      body: Align(
        alignment: goldenRatioVerticalAlignment,
        child: result,
      ),
    );
  }

}