import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:from_zero_ui/from_zero_ui.dart';

late final ChangeNotifierProvider<ThemeParameters> themeParametersProvider;

class ThemeParameters extends ThemeParametersFromZero {
  @override
  ThemeData get defaultLightTheme => clearLightTheme;

  ThemeData get clearLightTheme {
    final opaqueLightTheme = this.opaqueLightTheme;
    return opaqueLightTheme.copyWith(
      appBarTheme: AppBarTheme(
        color: opaqueLightTheme.cardColor,
        scrolledUnderElevation: 0,
        titleTextStyle: const TextStyle(
          color: Colors.black,
          fontSize: 24,
          fontWeight: FontWeight.w600,
        ),
        toolbarTextStyle: const TextStyle(color: Colors.black),
        actionsIconTheme: const IconThemeData(color: Colors.black),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
    );
  }

  static const lightBackgroundColor = Color.fromRGBO(230, 230, 240, 1);
  static const lightForegroundColor = Color.fromRGBO(250, 250, 255, 1);
  static final lightDividerColor = Colors.grey.shade400;
  static const lightSplashColor = Colors.blue;
  ThemeData get opaqueLightTheme {
    final theme = ThemeData(
      useMaterial3: true,
      visualDensity: VisualDensity.compact,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.indigo,
        // primary: Colors.blue.shade800,
        // secondary: Colors.blue.shade700,
      ),
      // primaryColorDark: const Color.fromRGBO(0, 0, 100, 1),
      // primaryColorLight: const Color.fromRGBO(0, 0, 140, 1),
      indicatorColor: lightSplashColor,
      focusColor: lightSplashColor.withOpacity(0.1),
      hoverColor: lightSplashColor.withOpacity(0.05),
      highlightColor: lightSplashColor.withOpacity(0.05),
      splashColor: lightSplashColor.withOpacity(0.1),
      canvasColor: lightBackgroundColor,
      scaffoldBackgroundColor: lightBackgroundColor,
      cardColor: lightForegroundColor,
      dividerColor: lightDividerColor,
      splashFactory: InkSparkle.splashFactory,
      cardTheme: const CardTheme(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        color: lightForegroundColor,
        surfaceTintColor: lightForegroundColor,
        elevation: 5,
      ),
      dialogBackgroundColor: lightForegroundColor,
      dialogTheme: const DialogTheme(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        backgroundColor: lightForegroundColor,
        surfaceTintColor: lightForegroundColor,
      ),
      appBarTheme: const AppBarTheme(
        color: Color.fromRGBO(0, 0, 100, 1),
        scrolledUnderElevation: 0,
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.w600,
        ),
        toolbarTextStyle: TextStyle(color: Colors.white),
        actionsIconTheme: IconThemeData(color: Colors.white),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      scrollbarTheme: ScrollbarThemeData(
        crossAxisMargin: 0,
        mainAxisMargin: 0,
        minThumbLength: 128,
        interactive: true,
        trackVisibility: MaterialStateProperty.resolveWith((states) {
          return states.contains(MaterialState.hovered);
        }),
        thumbVisibility: PlatformExtended.isDesktop ? const MaterialStatePropertyAll(true) : null,
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
      dividerTheme: DividerThemeData(color: lightDividerColor),
      listTileTheme: const ListTileThemeData(horizontalTitleGap: 12),
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: lightForegroundColor.withOpacity(0.9),
          borderRadius: const BorderRadius.all(Radius.circular(16)),
          border: Border.all(color: darkForegroundColor.withOpacity(0.33)),
        ),
        padding: const EdgeInsets.fromLTRB(12, 4, 12, 6),
        textStyle: const TextStyle(fontSize: 16, color: Colors.black),
      ),
    );
    return theme.copyWith(
      listTileTheme: theme.listTileTheme.copyWith(
        titleTextStyle: theme.textTheme.bodyLarge!.copyWith(
          height: 1.3,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  @override
  ThemeData get defaultDarkTheme => clearDarkTheme;

  ThemeData get clearDarkTheme {
    final opaqueDarkTheme = this.opaqueDarkTheme;
    return opaqueDarkTheme.copyWith(
      appBarTheme: opaqueDarkTheme.appBarTheme.copyWith(
        color: opaqueDarkTheme.cardColor,
      ),
    );
  }

  static const darkBackgroundColor = Color.fromRGBO(0, 0, 0, 1);
  static const darkForegroundColor = Color.fromRGBO(20, 20, 28, 1);
  static final darkDividerColor = Colors.grey.shade800;
  static final darkIconColor = Colors.grey.shade400;
  static final darkTextColor = Colors.grey.shade200;
  static final darkSplashColor = Colors.blue.shade600;
  ThemeData get opaqueDarkTheme {
    final theme = ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      visualDensity: VisualDensity.compact,
      colorScheme: ColorScheme.fromSwatch(
        brightness: Brightness.dark,
        primarySwatch: Colors.indigo,
        // accentColor: Colors.blueAccent,
        cardColor: darkForegroundColor,
        backgroundColor: darkBackgroundColor,
      ),
      // primaryColor: const Color.fromRGBO(0, 0, 35, 1),
      // primaryColorDark: const Color.fromRGBO(0, 0, 15, 1),
      // primaryColorLight: const Color.fromRGBO(0, 0, 55, 1),
      indicatorColor: darkSplashColor,
      focusColor: darkSplashColor.withOpacity(0.1),
      hoverColor: darkSplashColor.withOpacity(0.05),
      highlightColor: darkSplashColor.withOpacity(0.05),
      splashColor: darkSplashColor.withOpacity(0.1),
      canvasColor: darkBackgroundColor,
      scaffoldBackgroundColor: darkBackgroundColor,
      cardColor: darkForegroundColor,
      dividerColor: darkDividerColor,
      splashFactory: InkSparkle.splashFactory,
      cardTheme: const CardTheme(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        color: darkForegroundColor,
        surfaceTintColor: darkForegroundColor,
        elevation: 5,
      ),
      // dialogBackgroundColor: darkForegroundColor,
      dialogTheme: const DialogTheme(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        backgroundColor: darkForegroundColor,
        surfaceTintColor: darkForegroundColor,
      ),
      appBarTheme: const AppBarTheme(
        color: Color.fromRGBO(0, 0, 35, 1),
        scrolledUnderElevation: 0,
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.w600,
        ),
        toolbarTextStyle: TextStyle(color: Colors.white),
        actionsIconTheme: IconThemeData(color: Colors.white),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      scrollbarTheme: ScrollbarThemeData(
        crossAxisMargin: 0,
        mainAxisMargin: 0,
        minThumbLength: 128,
        interactive: true,
        trackVisibility: MaterialStateProperty.resolveWith((states) {
          return states.contains(MaterialState.hovered);
        }),
        thumbVisibility: PlatformExtended.isDesktop ? const MaterialStatePropertyAll(true) : null,
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
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: darkForegroundColor.withOpacity(0.9),
          borderRadius: const BorderRadius.all(Radius.circular(16)),
          border: Border.all(color: lightForegroundColor.withOpacity(0.33)),
        ),
        padding: const EdgeInsets.fromLTRB(12, 4, 12, 6),
        textStyle: const TextStyle(fontSize: 16, color: Colors.white),
      ),
      dividerTheme: DividerThemeData(color: darkDividerColor),
      listTileTheme: const ListTileThemeData(horizontalTitleGap: 12),
      switchTheme: SwitchThemeData(
        trackColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return Colors.blue.shade900;
          }
          return Colors.grey.shade900;
        }),
      ),
    );
    return theme.copyWith(
      colorScheme: theme.colorScheme.copyWith(outline: darkDividerColor),
      textTheme: theme.textTheme.copyWith(
        labelSmall: theme.textTheme.labelSmall!.copyWith(
          color: theme.textTheme.labelSmall!.color == Colors.white ? darkTextColor : theme.textTheme.labelSmall!.color,
        ),
        labelMedium: theme.textTheme.labelMedium!.copyWith(
          color: theme.textTheme.labelMedium!.color == Colors.white
              ? darkTextColor
              : theme.textTheme.labelMedium!.color,
        ),
        labelLarge: theme.textTheme.labelLarge!.copyWith(
          color: theme.textTheme.labelLarge!.color == Colors.white ? darkTextColor : theme.textTheme.labelLarge!.color,
        ),
        bodySmall: theme.textTheme.bodySmall!.copyWith(
          color: theme.textTheme.bodySmall!.color == Colors.white ? darkTextColor : theme.textTheme.bodySmall!.color,
        ),
        bodyMedium: theme.textTheme.bodyMedium!.copyWith(
          color: theme.textTheme.bodyMedium!.color == Colors.white ? darkTextColor : theme.textTheme.bodyMedium!.color,
        ),
        bodyLarge: theme.textTheme.bodyLarge!.copyWith(
          color: theme.textTheme.bodyLarge!.color == Colors.white ? darkTextColor : theme.textTheme.bodyLarge!.color,
        ),
        titleSmall: theme.textTheme.titleSmall!.copyWith(
          color: theme.textTheme.titleSmall!.color == Colors.white ? darkTextColor : theme.textTheme.titleSmall!.color,
        ),
        titleMedium: theme.textTheme.titleMedium!.copyWith(
          color: theme.textTheme.titleMedium!.color == Colors.white
              ? darkTextColor
              : theme.textTheme.titleMedium!.color,
        ),
        titleLarge: theme.textTheme.titleLarge!.copyWith(
          color: theme.textTheme.titleLarge!.color == Colors.white ? darkTextColor : theme.textTheme.titleLarge!.color,
        ),
        headlineSmall: theme.textTheme.headlineSmall!.copyWith(
          color: theme.textTheme.headlineSmall!.color == Colors.white
              ? darkTextColor
              : theme.textTheme.headlineSmall!.color,
        ),
        headlineMedium: theme.textTheme.headlineMedium!.copyWith(
          color: theme.textTheme.headlineMedium!.color == Colors.white
              ? darkTextColor
              : theme.textTheme.headlineMedium!.color,
        ),
        headlineLarge: theme.textTheme.headlineLarge!.copyWith(
          color: theme.textTheme.headlineLarge!.color == Colors.white
              ? darkTextColor
              : theme.textTheme.headlineLarge!.color,
        ),
        displaySmall: theme.textTheme.displaySmall!.copyWith(
          color: theme.textTheme.displaySmall!.color == Colors.white
              ? darkTextColor
              : theme.textTheme.displaySmall!.color,
        ),
        displayMedium: theme.textTheme.displayMedium!.copyWith(
          color: theme.textTheme.displayMedium!.color == Colors.white
              ? darkTextColor
              : theme.textTheme.displayMedium!.color,
        ),
        displayLarge: theme.textTheme.displayLarge!.copyWith(
          color: theme.textTheme.displayLarge!.color == Colors.white
              ? darkTextColor
              : theme.textTheme.displayLarge!.color,
        ),
      ),
      listTileTheme: theme.listTileTheme.copyWith(
        titleTextStyle: theme.textTheme.bodyLarge!.copyWith(
          height: 1.3,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
      iconTheme: theme.iconTheme.copyWith(color: darkIconColor),
    );
  }
}
