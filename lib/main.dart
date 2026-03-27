import 'dart:async';
import 'dart:io';

import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:collection_app/router.dart';
import 'package:collection_app/theme_parameters.dart';
import 'package:collection_app/util/logging.dart';
import 'package:collection_app/widgets/utils/db_process_indicator_overlay.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:from_zero_ui/from_zero_ui.dart';
import 'package:from_zero_ui/util/web_initial_config/web_initial_config.dart';
import 'package:fvp/fvp.dart' as fvp;
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';
import 'package:mlog/mlog.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() async {
  await initLogging();
  fvp.registerWith(
    options: {
      'video.decoders': ['FFmpeg'], // Use software decoding, it crashes on linux otherwise
    },
  );
  databaseFactory = databaseFactoryFfi; // init sqflite // TODO: 3 maybe move this somewhere else?
  // TODO: 2 implement proper handling of flutter errors in mlog
  if (kReleaseMode) {
    FlutterError.onError = (FlutterErrorDetails details) {
      log(
        LgLvl.error,
        'FLUTTER ERROR CAUGHT BY LOGGER',
        e: details.exception,
        st: details.stack,
        details: details,
      );
    };
  }
  runZonedGuarded(startApp, (dynamic error, StackTrace stackTrace) {
    log(
      LgLvl.error,
      'TOP LEVEL RUN ZONE GUARDED ERROR',
      e: error,
      st: stackTrace,
    );
  });
}

Future<void> initLogging() async {
  LogOptions.instance.relevantStackTraceLineOffset = 2;
  if (kReleaseMode) {
    try {
      initLoggingDebug();
      // await initLoggingRelease(); // TODO: 3 implement release logging, maybe create a package with MPG stuff
    } catch (_) {
      initLoggingDebug();
    }
  } else {
    initLoggingDebug();
  }
  LogOptions.instance.setLevel(LgLvl.fine);
  LogOptions.instance.addTypes({
    FzLgType.routing: LgLvl.info,
    FzLgType.appUpdate: LgLvl.info,
    FzLgType.dao: LgLvl.info,
    LgType.script: LgLvl.finer,
    LgType.db: LgLvl.info,
  });
}

void initLoggingDebug() {
  log =
      (
        LgLvl level,
        String? msg, {
        Object? type,
        Object? e,
        StackTrace? st,
        Map<String, Object>? data,
        int extraTraceLineOffset = 0,
        FlutterErrorDetails? details,
      }) {
        if (level.value > LogOptions.instance.getLvlForType(type).value) {
          return;
        }
        final message = defaultLogGetString(
          level,
          msg,
          e: e,
          st: st,
          extraTraceLineOffset: extraTraceLineOffset,
          type: type,
          details: details,
        );
        if (message != null) {
          if (PlatformExtended.isAndroid) {
            // TODO: 3 better logging handling in Android
            // in android, stdout.writeln doesn't show in dev console
            print(message); // ignore: avoid_print
          } else {
            stdout.writeln(message);
          }
        }
      };
}

/// this method needs to be called inside the final flutter zone
Future<void> startApp() async {
  initAppConfigWebSensitive();
  FromZeroAppContentWrapper.windowsProcessName = 'collection_app.exe';
  FromZeroAppContentWrapper.appNameForCloseConfirmation = 'Collection App';
  // WindowBar.logoImageAssetsPath = 'assets/images/logo.png'; // TODO: 2 re-add when we get a logo
  await initHive(kReleaseMode ? 'collection_app' : 'collection_app_debug');
  PlatformExtended.customDownloadsDirectory = Hive.box<dynamic>(
    'settings',
  ).get('download_folder');
  themeParametersProvider = ChangeNotifierProvider((ref) {
    return ThemeParameters();
  });
  fromZeroThemeParametersProvider = themeParametersProvider;
  RendererBinding.instance.deferFirstFrame();
  runApp(const App());
  if (!kIsWeb && Platform.isWindows) {
    if (kReleaseMode) {
      try {
        doWhenWindowReady(() {
          try {
            appWindow.minSize = const Size(512, 512);
            appWindow.size = const Size(1280, 720);
            appWindow.alignment = Alignment.center;
            appWindow.maximize();
            appWindow.show();
          } catch (e, st) {
            _reportWindowError(e, st);
          }
        });
      } catch (e, st) {
        _reportWindowError(e, st);
      }
    } else {
      doWhenWindowReady(() {
        appWindow.minSize = const Size(512, 512);
        appWindow.show();
      });
    }
  }
}

void _reportWindowError(Object e, StackTrace st) {
  File logFile = File('cutrans_3.0_log_window.txt')..createSync(recursive: true);
  final logFileWrite = logFile.openWrite();
  logFileWrite.writeln('FATAL ERROR WHILE SHOWING WINDOW');
  logFileWrite.writeln(e.toString());
  logFileWrite.writeln(st.toString());
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> with WidgetsBindingObserver {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey();
  late final GoRouter router = GoRouter(
    initialLocation: '/splash',
    // debugLogDiagnostics: true,
    navigatorKey: navigatorKey,
    routes: GoRouteFromZero.getCleanRoutes(buildRoutes()),
  );

  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   // seems to not work on windows :)))
  //   switch (state) {
  //     case AppLifecycleState.detached:
  //       for (final e in collectionService.getAllCollections()) {
  //         DbHelper.closeDbForCollection(e);
  //       }
  //     case AppLifecycleState.resumed:
  //     case AppLifecycleState.inactive:
  //     case AppLifecycleState.hidden:
  //     case AppLifecycleState.paused:
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: Consumer(
        builder: (context, ref, child) {
          final themeParameters = ref.watch(themeParametersProvider);
          return MaterialApp.router(
            title: 'Collection App',
            routerConfig: router,
            debugShowCheckedModeBanner: false,
            supportedLocales: const [Locale('en')],
            localizationsDelegates: const [
              ...GlobalMaterialLocalizations.delegates,
              FromZeroLocalizations.delegate,
              //              AppLocalizations.delegate,
            ],
            shortcuts: {
              ...WidgetsApp.defaultShortcuts,
              ...fromZeroDefaultShortcuts,
            },
            actions: {...WidgetsApp.defaultActions},
            themeMode: ThemeMode.dark,
            // themeMode: themeParameters.themeMode,
            theme: themeParameters.lightTheme,
            darkTheme: themeParameters.darkTheme,
            builder: (context, child) {
              return FromZeroAppContentWrapper(
                goRouter: router,
                child: DbProcessIndicatorOverlay(child: child!),
              );
            },
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    // WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void initState() {
    super.initState();
    RendererBinding.instance.allowFirstFrame();
    // WidgetsBinding.instance.addObserver(this);
  }
}
