import 'dart:io';

import 'package:collection_app/pages/page_not_found.dart';
import 'package:collection_app/providers/_isar_provider.dart';
import 'package:collection_app/router.dart';
import 'package:collection_app/theme_parameters.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:from_zero_ui/from_zero_ui.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';


const appDirectorySubDir = 'Collections';


void main() async {

  // init from_zero_ui stuff
  await initHive(appDirectorySubDir);
  themeParametersProvider = ChangeNotifierProvider((ref) {
    return ThemeParameters();
  });
  fromZeroThemeParametersProvider = themeParametersProvider;

  // TODO 3 setup error handling/reporting
  runApp(MyApp());

  // initialize bitsdojo_window on desktop
  if (PlatformExtended.appWindow!=null) {
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
        appWindow.show();
      });
    }
  }

}
_reportWindowError(e, st) {
  File logFile = File('log_window.txt')..createSync(recursive: true);
  final logFileWrite = logFile.openWrite();
  logFileWrite.writeln('FATAL ERROR WHILE SHOWING WINDOW');
  logFileWrite.writeln(e.toString());
  logFileWrite.writeln(st.toString());
}


class MyApp extends StatelessWidget {

  MyApp({Key? key}) : super(key: key);

  final _router = GoRouter(
    // debugLogDiagnostics: true,
    redirect: (context, state) async {
      if ((!initialized) && state.matchedLocation!='/') {
        // ensure to always go through splash screen
        return '/?redirect=${state.matchedLocation}';
      }
      // no need to redirect at all
      return null;
    },
    errorBuilder: (context, state) {
      return OnlyOnActiveBuilder(
        state: state,
        route: RouteNotFound(),
        builder: (context, state) {
          return const PageNotFound();
        },
      );
    },
    routes: GoRouteFromZero.getCleanRoutes(buildRoutes()),
  );

  @override
  Widget build(context) {
    return ProviderScope(
      child: Consumer(
        builder: (context, ref, child) {
          final themeParameters = ref.watch(themeParametersProvider);
          return MaterialApp.router(
            routeInformationParser: _router.routeInformationParser,
            routerDelegate: _router.routerDelegate,
            routeInformationProvider: _router.routeInformationProvider,
            title: 'Collections',
            debugShowCheckedModeBanner: false,
            locale: themeParameters.appLocale,
            // supportedLocales: List.from(themeParameters.supportedLocales)..remove(null),
            supportedLocales: const [Locale('en')],
            localizationsDelegates: const [
              // AppLocalizations.delegate,
              FromZeroLocalizations.delegate,
              ...GlobalMaterialLocalizations.delegates,
            ],
            shortcuts: {
              ...WidgetsApp.defaultShortcuts,
              ...fromZeroDefaultShortcuts,
            },
            themeMode: themeParameters.themeMode,
            theme: themeParameters.lightTheme,
            darkTheme: themeParameters.darkTheme,
            builder: (context, child) {
              return FromZeroAppContentWrapper(
                goRouter: _router,
                child: child!,
              );
            },
          );
        },
      ),
    );
  }

}
