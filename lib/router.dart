import 'package:collection_app/widgets/main_page.dart';
import 'package:collection_app/widgets/splash_page.dart';
import 'package:from_zero_ui/from_zero_ui.dart';

List<GoRouteFromZero> buildRoutes() {
  return [RouteSplash(), RouteMain()];
}

class RouteSplash extends GoRouteFromZero {
  RouteSplash()
    : super(
        path: '/splash',
        name: 'splash',
        title: 'Splash',
        pageScaffoldId: 'splash',
        builder: (context, state) => const PageSplash(),
      );
}

class RouteMain extends GoRouteFromZero {
  RouteMain()
    : super(
        path: '/main',
        name: 'main',
        title: 'Collection App',
        pageScaffoldId: 'main',
        builder: (context, state) => const MainPage(),
      );
}
