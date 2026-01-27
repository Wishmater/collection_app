import 'package:collection_app/models/collection.dart';
import 'package:collection_app/providers/collection_provider.dart';
import 'package:collection_app/router.dart';
import 'package:collection_app/util/database_helper.dart';
import 'package:dartx/dartx_io.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:from_zero_ui/from_zero_ui.dart';
import 'package:hive/hive.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class PageSplash extends ConsumerStatefulWidget {
  const PageSplash({super.key});

  @override
  PageSplashState createState() => PageSplashState();
}

class PageSplashState extends ConsumerState<PageSplash> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      init();
    });
  }

  Future<void> init() async {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      sqfliteFfiInit();

      final collectionsBox = await Hive.openBox<List<dynamic>>('collections');
      List<(String, String, DateTime)> collectionsData = [];
      for (final key in collectionsBox.keys) {
        final value = collectionsBox.get(key)!;
        collectionsData.add((key, value[0], value[1]));
      }
      collectionsData = collectionsData.sortedByDescending((e) => e.$3);
      for (final e in collectionsData) {
        final collection = Collection(name: e.$2, baseDirectory: e.$1);
        CollectionProvider.addCollection(
          ref,
          collection,
          checkIfAlreadyExists: false,
          saveToDb: false,
        );
      }
      await DbHelper.waitForAllDbOperationsToFinish();

      if (context.mounted) {
        RouteMain().go(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Widget result = IntrinsicWidth(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "Initializing...",
            style: TextStyle(fontSize: 18),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 6),
          Container(
            width: 256,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(32)),
            ),
            clipBehavior: Clip.antiAlias,
            child: LinearProgressIndicator(color: theme.colorScheme.primary),
          ),
        ],
      ),
    );

    final scrollController = ScrollController();
    return ScaffoldFromZero(
      mainScrollController: scrollController,
      appbarType: AppbarType.none,
      body: Align(alignment: goldenRatioVerticalAlignment, child: result),
    );
  }
}
