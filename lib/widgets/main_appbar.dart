import 'package:collection_app/providers/app_state_provider.dart';
import 'package:collection_app/providers/collection_provider.dart';
import 'package:collection_app/providers/tag_provider.dart';
import 'package:collection_app/scripts/_scripts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:from_zero_ui/from_zero_ui.dart';
import 'package:from_zero_ui/src/app_scaffolding/api_snackbar.dart';


class MainAppbar extends ConsumerStatefulWidget {

  const MainAppbar({
    super.key,
  });

  @override
  ConsumerState<MainAppbar> createState() => _MainAppbarState();

}

class _MainAppbarState extends ConsumerState<MainAppbar> {

  final GlobalKey<ContextMenuFromZeroState> popupGlobalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return AppbarFromZero(
      backgroundColor: Colors.transparent,
      title: Container(
        width: 160,
        alignment: Alignment.centerLeft,
        child: ContextMenuFromZero(
          key: popupGlobalKey,
          useCursorLocation: false,
          anchorAlignment: Alignment.topLeft,
          offsetCorrection: const Offset(-16, -4),
          contextMenuWidget: Consumer(
            builder: (context, ref, child) {
              final collections = ref.watch(CollectionProvider.all);
              final includingCollections = ref.watch(AppStateProvider.filterIncludingCollections);
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppbarFromZero(
                    title: Text('Collections',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    actions: [
                      ActionFromZero(
                        title: 'Load Collection...',
                        icon: const Icon(Icons.create_new_folder),
                        onTap: (context) {
                          // TODO 1 implement selecting a folder for collection,
                          //  including warning that it will be created if it doesn't already exist,
                          //  and validating that it isn't inside an existing collection
                        },
                      ),
                    ],
                  ),
                  if (collections.isEmpty)
                    const ErrorSign(title: 'No collections registered...'),
                  if (collections.isNotEmpty)
                    ...collections.map((e) {
                      // TODO 3 implement excluding collections
                      return CheckboxListTile(
                        value: includingCollections.contains(e),
                        controlAffinity: ListTileControlAffinity.leading,
                        onChanged: (value) {
                          if (value!) {
                            ref.read(AppStateProvider.filterIncludingCollections.state)
                                .state = [...collections, e];
                          } else {
                            ref.read(AppStateProvider.filterIncludingCollections.state)
                                .state = List.from(collections)..remove(e);
                          }
                        },
                        title: Text(e.name),
                      );
                    }),
                ],
              );
            },
          ),
          child: TextButton(
            child: Text('Collections',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            onPressed: () {
              popupGlobalKey.currentState!.showContextMenu();
            },
          ),
        ),
      ),
      actions: [
        ActionFromZero(
          title: 'Scripts',
          icon: const Icon(MaterialCommunityIcons.script_text),
          breakpoints: {0: ActionState.overflow},
          onTap: (context) {
            showModalFromZero(context: context,
              builder: (context) {
                return DialogFromZero(
                  title: const Text('Scripts'),
                  contentPadding: EdgeInsets.zero,
                  maxWidth: 512,
                  dialogActions: const [
                    DialogButton.cancel(
                      child: Text('CLOSE'),
                    ),
                  ],
                  content: Column(
                    children: registeredScripts.map((e) {
                      return ListTile(
                        title: Text(e.name),
                        subtitle: Text(e.description),
                        onTap: () {
                          APISnackBar(context: context,
                            stateNotifier: ApiState.noProvider((_) {
                              return e.callback().then((value) async {
                                ref.invalidate(CollectionProvider.all);
                                ref.invalidate(TagProvider.all);
                              });
                            }),
                            cancelable: false,
                            successTitle: 'Script executed successfully',
                            successMessage: e.name,
                          ).show();
                        },
                      );
                    }).toList(),
                  ),
                );
              },
            );
          },
        ),
        ActionFromZero(
          title: 'Settings',
          icon: const Icon(Icons.settings),
          breakpoints: {0: ActionState.overflow},
          onTap: (context) {

          },
        ),
      ],
    );
  }


}
