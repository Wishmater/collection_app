import 'package:collection_app/daos/collection.dart';
import 'package:collection_app/models/collection.dart';
import 'package:collection_app/providers/_isar_provider.dart';
import 'package:collection_app/providers/collection_provider.dart';
import 'package:collection_app/router.dart';
import 'package:collection_app/theme_parameters.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:from_zero_ui/from_zero_ui.dart';
import 'package:from_zero_ui/util/my_sticky_header.dart';
import 'package:go_router/go_router.dart';


class PageSplash extends ConsumerStatefulWidget {

  final String redirectPath;

  const PageSplash({
    required this.redirectPath,
    Key? key,
  }) : super(key: key);

  @override
  PageSplashState createState() => PageSplashState();

}


class PageSplashState extends ConsumerState<PageSplash> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await Future.delayed(const Duration(milliseconds: 200));
      if (mounted) {
        init();
      }
    });
  }

  Object? error;
  void init() async{
    try {
      initialized = true;
      if (ref.read(IsarProvider.selectedCollectionName)!=null) {
        String redirectPath = widget.redirectPath=='/' ? '/home' : widget.redirectPath;
        if (mounted) {
          GoRouter.of(context).go(redirectPath);
        }
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
      result = ApiProviderBuilder<List<CollectionData>>(
        provider: CollectionProvider.all,
        dataBuilder: (context, collections) {
          final scrollController = ScrollController();
          return Center(
            child: ResponsiveHorizontalInsets(
              child: SizedBox(
                width: 612,
                child: Card(
                  child: ScrollbarFromZero(
                    controller: scrollController,
                    child: StickyHeader(
                      controller: scrollController,
                      header: AppbarFromZero(
                        title: const Text('Collections'),
                        actions: [
                          ActionFromZero(
                            title: 'New Collection',
                            icon: const Icon(Icons.add),
                            onTap: (actionContext) {
                              CollectionDAO.buildDao(null).maybeEdit(context);
                            },
                          ),
                        ],
                      ),
                      content: ListView.builder(
                        controller: scrollController,
                        itemCount: collections.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(collections[index].name),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
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
