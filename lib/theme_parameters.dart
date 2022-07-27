import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:from_zero_ui/from_zero_ui.dart';
import 'package:hive/hive.dart';

late final ChangeNotifierProvider<ThemeParameters> themeParametersProvider;

class ThemeParameters extends ThemeParametersFromZero{

  @override
  ThemeData get defaultLightTheme => ThemeData(
    canvasColor: Colors.grey.shade300,
    primarySwatch: Colors.indigo,
    accentColor: Colors.cyanAccent,
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
      isAlwaysShown: PlatformExtended.isDesktop,
      showTrackOnHover: true,
      crossAxisMargin: 0,
      mainAxisMargin: 0,
      minThumbLength: 128,
      interactive: true,
      thumbColor: MaterialStateProperty.resolveWith((states) {
        Color color = Colors.grey.shade800;
        if (states.contains(MaterialState.dragged)) {
          return color.withOpacity(0.90);
        }
        if (states.contains(MaterialState.hovered)) {
          return color.withOpacity(0.80);
        }
        return color.withOpacity(0.70);
      }),
    ),
  );

  @override
  ThemeData get defaultDarkTheme => ThemeData(
    brightness: Brightness.dark,
    primarySwatch: Colors.blue,
    accentColor: Colors.cyanAccent,
    hoverColor: Colors.cyanAccent.withOpacity(0.1),
    highlightColor: Colors.cyanAccent.withOpacity(0.1),
    splashColor: Colors.cyanAccent.withOpacity(0.25),
//    secondaryHeaderColor: Color.fromRGBO(180, 143, 107, 1),
    errorColor: Colors.red.shade500,
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
      isAlwaysShown: PlatformExtended.isDesktop,
      showTrackOnHover: true,
      crossAxisMargin: 0,
      mainAxisMargin: 0,
      minThumbLength: 128,
      interactive: true,
      thumbColor: MaterialStateProperty.resolveWith((states) {
        Color color = Colors.grey.shade300;
        if (states.contains(MaterialState.dragged)) {
          return color.withOpacity(0.90);
        }
        if (states.contains(MaterialState.hovered)) {
          return color.withOpacity(0.80);
        }
        return color.withOpacity(0.70);
      }),
    ),
  );


  static Color getCharactersColor(context){
    return Theme.of(context).brightness==Brightness.light ? darkCharactersColor : lightCharactersColor;
  }
  static Color get lightCharactersColor => Colors.green.shade300;
  static Color get darkCharactersColor => Colors.green.shade900;
  static Color getOriginsColor(context){
    return Theme.of(context).brightness==Brightness.light ? darkOriginsColor : lightOriginsColor;
  }
  static Color get lightOriginsColor => Colors.orange.shade300;
  static Color get darkOriginsColor => Colors.orange.shade900;


}