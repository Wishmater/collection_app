import 'dart:io';

import 'package:collection_app/models/collection.dart';
import 'package:collection_app/router.dart';
import 'package:collection_app/scripts/import_prnhb_channels.dart';
import 'package:collection_app/services/collection_service.dart';
import 'package:collection_app/util/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:from_zero_ui/from_zero_ui.dart';
import 'package:sqflite_common/sqlite_api.dart';
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
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async{
      sqfliteFfiInit();

      // await importPrnhbChannels(); // TODO 1 remove this from main once we have persisted data

      final rootFolder = Directory(r'D:\Polnareff\prnhb\!channels');
      final collection = Collection(
        name: 'Prnhb Channels',
        baseDirectory: rootFolder.absolute.path,
      );
      collectionService.addCollection(collection,
        checkIfAlreadyExists: false,
        saveToDb: false,
      );
      await DbHelper.waitForAllDbOperationsToFinish();

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