import 'package:collection_app/daos/collection.dart';
import 'package:collection_app/models/collection.dart';
import 'package:collection_app/providers/_isar_provider.dart';
import 'package:collection_app/providers/collection_provider.dart';
import 'package:collection_app/router.dart';
import 'package:collection_app/theme_parameters.dart';
import 'package:flutter/material.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:from_zero_ui/from_zero_ui.dart';
import 'package:from_zero_ui/util/copied_flutter_widgets/my_sliver_sticky_header.dart';
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
      if (ref.read(IsarProvider.selectedCollectionId)!=null) {
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
  Widget build(BuildContext mnainContext) {
    Widget result;
    if (error==null) {
      result = ApiProviderBuilder<List<CollectionData>>(
        provider: CollectionProvider.all,
        dataBuilder: (context, collections) {
          final scrollController = ScrollController();
          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 6),
              child: ResponsiveHorizontalInsets(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 512, minHeight: 512),
                  child: Card(
                    clipBehavior: Clip.antiAlias,
                    child: ScrollbarFromZero(
                      controller: scrollController,
                      applyOpacityGradientToChildren: false,
                      child: ScrollOpacityGradient(
                        scrollController: scrollController,
                        applyAtStart: false,
                        child: CustomScrollView(
                          controller: scrollController,
                          shrinkWrap: true,
                          slivers: [
                            SliverStickyHeader.builder(
                              builder: (context, state) {
                                return Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    AppbarFromZero(
                                      title: const Text('Collections'),
                                      backgroundColor: Theme.of(context).cardColor,
                                      elevation: 8.0 * state.scrollPercentage,
                                      actions: [
                                        ActionFromZero(
                                          title: 'New Collection',
                                          icon: const Icon(Icons.add),
                                          onTap: (actionContext) {
                                            CollectionDAO.buildDao(null).maybeEdit(mnainContext);
                                          },
                                        ),
                                      ],
                                    ),
                                    AnimatedPositioned(
                                      left: 0, right: 0, bottom: -2,
                                      height: state.isPinned ? 2 : 0,
                                      duration: const Duration(milliseconds: 300),
                                      curve: Curves.easeOutCubic,
                                      child: const CustomPaint(
                                        painter: SimpleShadowPainter(
                                          direction: SimpleShadowPainter.down,
                                          shadowOpacity: 0.2,
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                              sliver: SliverList(
                                delegate: SliverChildListDelegate(
                                  [
                                    ...collections.map((e) {
                                      return ListTile(
                                        title: Text(e.name),
                                        onTap: () {
                                          ref.read(IsarProvider.selectedCollectionId.state).state = e.id;
                                          IsarProvider.lastOpenedCollection = e.id;
                                          RouteHome().go(context);
                                        },
                                      );
                                    }).toList(),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
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
