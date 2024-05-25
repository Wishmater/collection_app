import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:from_zero_ui/from_zero_ui.dart';
import 'package:hive/hive.dart';

late final ChangeNotifierProvider<ThemeParameters> themeParametersProvider;

class ThemeParameters extends ThemeParametersFromZero{

  // TODO 2 remove deprecations and update theme parameters to achieve a custom look and feel
  @override
  ThemeData get defaultLightTheme => ThemeData(
    canvasColor: Colors.grey.shade300,
    // primarySwatch: Colors.indigo,
    // accentColor: Colors.cyanAccent,
    colorScheme: ColorScheme.fromSwatch(
      primarySwatch: Colors.indigo,
      accentColor: Colors.cyanAccent,
    ),
    hoverColor: Colors.cyanAccent.withOpacity(0.1),
    highlightColor: Colors.cyanAccent.withOpacity(0.1),
    splashColor: Colors.cyanAccent.withOpacity(0.25),
//    secondaryHeaderColor: Color.fromRGBO(113, 82, 52, 1),
    visualDensity: VisualDensity.compact,
    textTheme: const TextTheme(
      headline1: TextStyle(
        fontFamily: 'Baloo',
        fontFamilyFallback: ['Roboto'],
        fontSize: 32,
        color: Colors.cyanAccent,
      ),
    ),
    tooltipTheme: TooltipThemeData(
      decoration: BoxDecoration(
        color: Colors.grey.shade700.withOpacity(0.9),
        borderRadius: const BorderRadius.all(Radius.circular(999999)),
      ),
      padding: const EdgeInsets.fromLTRB(12, 4, 12, 6),
      textStyle: const TextStyle(
        fontSize: 16,
        color: Colors.white,
      ),
    ),
    scrollbarTheme: ScrollbarThemeData(
      crossAxisMargin: 0,
      mainAxisMargin: 0,
      minThumbLength: 128,
      interactive: true,
      trackVisibility: MaterialStateProperty.resolveWith((states) {
        return states.contains(MaterialState.hovered);
      }),
      thumbVisibility: PlatformExtended.isDesktop
          ? const MaterialStatePropertyAll(true)
          : null,
      trackColor: MaterialStateProperty.resolveWith((states) {
        return const Color.fromRGBO(255, 255, 255, 0.4);
      }),
      thumbColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.dragged)) {
          return const Color.fromRGBO(101, 101, 101, 1); // 0.6
        }
        if (states.contains(MaterialState.hovered)) {
          return const Color.fromRGBO(127, 127, 127, 1); // 0.5
        }
        return const Color.fromRGBO(153, 153, 153, 1); // 0.4
      }),
    ),
  );

  @override
  ThemeData get defaultDarkTheme => ThemeData(
    brightness: Brightness.dark,
    // primarySwatch: Colors.blue,
    // accentColor: Colors.cyanAccent,
    // primarySwatch: Colors.indigo,
    // accentColor: Colors.cyanAccent,
    colorScheme: ColorScheme.fromSwatch(
      primarySwatch: Colors.indigo,
      accentColor: Colors.cyanAccent,
      brightness: Brightness.dark,
    ),
    hoverColor: Colors.cyanAccent.withOpacity(0.1),
    highlightColor: Colors.cyanAccent.withOpacity(0.1),
    splashColor: Colors.cyanAccent.withOpacity(0.25),
//    secondaryHeaderColor: Color.fromRGBO(180, 143, 107, 1),
    errorColor: Colors.red.shade500,
    visualDensity: VisualDensity.compact,
    tooltipTheme: TooltipThemeData(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: const BorderRadius.all(Radius.circular(999999)),
      ),
      padding: const EdgeInsets.fromLTRB(12, 4, 12, 6),
      textStyle: const TextStyle(
        fontSize: 16,
        color: Colors.black,
      ),
    ),
    scrollbarTheme: ScrollbarThemeData(
      crossAxisMargin: 0,
      mainAxisMargin: 0,
      minThumbLength: 128,
      interactive: true,
      trackVisibility: MaterialStateProperty.resolveWith((states) {
        return states.contains(MaterialState.hovered);
      }),
      thumbVisibility: PlatformExtended.isDesktop
          ? const MaterialStatePropertyAll(true)
          : null,
      trackColor: MaterialStateProperty.resolveWith((states) {
        return const Color.fromRGBO(255, 255, 255, 0.1);
      }),
      thumbColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.dragged)) {
          return const Color.fromRGBO(153, 153, 153, 1); // 0.4
        }
        if (states.contains(MaterialState.hovered)) {
          return const Color.fromRGBO(127, 127, 127, 1); // 0.5
        }
        return const Color.fromRGBO(101, 101, 101, 1); // 0.6
      }),
    ),
  );

}