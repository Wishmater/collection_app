import 'package:collection_app/pages/page_home.dart';
import 'package:collection_app/pages/page_item.dart';
import 'package:collection_app/pages/page_not_found.dart';
import 'package:collection_app/pages/page_splash.dart';
import 'package:flutter/material.dart';
import 'package:from_zero_ui/from_zero_ui.dart';


bool initialized = false;

List<GoRouteFromZero> buildRoutes({bool forDrawer=false}) {
  return [
    RouteSplash(),
    RouteHome(),
  ];
}



class RouteHome extends GoRouteFromZero {
  RouteHome({
    List<GoRouteFromZero>? routes,
  }) : super(
    path: 'home',
    name: 'home',
    title: 'Home',
    icon: const Icon(Icons.home),
    builder: (context, state) => const PageHome(),
    routes: routes ?? [
      RouteItem(id: -1),
    ],
  );
}



class RouteItem extends GoRouteFromZero {
  final int id;
  RouteItem({
    Key? key,
    required this.id,
  }) : super(
    path: 'quiz/:id',
    name: 'quiz',
    title: 'Quiz',
    icon: const Icon(Icons.image),
    pageScaffoldDepth: 2,
    builder: (context, state) => const PageItem(
      // id: Uri.decodeComponent(state.params['id']!),
    ),
  );
  @override
  Map<String, String> get defaultParams => {
    'id': id.toString(),
  };
}



class RouteSplash extends GoRouteFromZero {
  final String? redirectPath;
  RouteSplash({
    Key? key,
    this.redirectPath,
  }) : super(
    path: '/',
    name: 'splash',
    pageScaffoldId: 'splash',
    builder: (context, state) {
      return PageSplash(
        redirectPath: redirectPath ?? '/home',
      );
    },
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: animation,
        child: child,
      );
    },
  );
  @override
  Map<String, String> get defaultQueryParams => {
    if (redirectPath!=null)
      'redirectPath': redirectPath!,
  };
}



class RouteNotFound extends GoRouteFromZero {
  RouteNotFound() : super(
    path: 'not_found',
    name: 'not_found',
    title: 'Page Not Found',
    icon: const Icon(Icons.broken_image),
    builder: (context, state) => const PageNotFound(),
  );
}