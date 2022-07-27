import 'package:collection_app/router.dart';
import 'package:collection_app/theme_parameters.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:from_zero_ui/from_zero_ui.dart';
import 'package:go_router/go_router.dart';


class PageSplash extends StatefulWidget {

  final String redirectPath;

  const PageSplash({
    required this.redirectPath,
    Key? key,
  }) : super(key: key);

  @override
  PageSplashState createState() => PageSplashState();

}


class PageSplashState extends State<PageSplash> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      init();
    });
  }

  Object? error;
  void init() async{
    try {
      initialized = true;
      await Future.delayed(const Duration(milliseconds: 200));
      String redirectPath = widget.redirectPath=='/' ? '/home' : widget.redirectPath;
      if (mounted) {
        GoRouter.of(context).go(redirectPath);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          error = e;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget result;
    if (error==null) {
      result = Column(
        mainAxisSize: MainAxisSize.min,
        children: const [
          // Hero(
          //   tag: "title_logo",
          //   child: Container(
          //     height: 96, width: 96,
          //     padding: const EdgeInsets.fromLTRB(6, 6, 0, 6),
          //     child: Image.asset('assets/images/logo.png', filterQuality: FilterQuality.medium,),
          //   ),
          // ),
          SizedBox(height: 12,),
          // SizedBox(
          //   width: 192,
          //   child: LinearProgressIndicator(
          //     valueColor: AlwaysStoppedAnimation(Theme.of(context).accentColor),
          //   ),
          // )
        ],
      );
    } else {
      result = Consumer(
        builder: (context, ref, child) {
          return Theme(
            data: ref.watch(themeParametersProvider).darkTheme,
            child: ErrorSign(
              icon: const Icon(MaterialCommunityIcons.wifi_off),
              title: FromZeroLocalizations.of(context).translate('error_connection'),
              subtitle: FromZeroLocalizations.of(context).translate('error_connection_details'),
              onRetry: () {
                setState(() {
                  error = null;
                });
                init();
              },
            ),
          );
        },
      );
    }
    return Container(
      color: Theme.of(context).primaryColor,
      alignment: Alignment.center,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        switchInCurve: Curves.easeOutCubic,
        switchOutCurve: Curves.easeInCubic,
        child: result,
        transitionBuilder: (child, animation) {
          return FadeTransition(
            opacity: animation,
            child: ScaleTransition(
              scale: animation,
              child: child,
            ),
          );
        },
      ),
    );
  }

}
