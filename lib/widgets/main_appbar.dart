import 'package:collection_app/models/collection.dart';
import 'package:collection_app/providers/app_state_provider.dart';
import 'package:collection_app/providers/collection_provider.dart';
import 'package:collection_app/providers/tag_provider.dart';
import 'package:collection_app/scripts/_scripts.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:from_zero_ui/from_zero_ui.dart';
import 'package:from_zero_ui/src/app_scaffolding/api_snackbar.dart';
import 'package:path/path.dart' as p;

class MainAppbar extends ConsumerStatefulWidget {
  const MainAppbar({super.key});

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
              final includingCollections = ref.watch(
                AppStateProvider.filterIncludingCollections,
              );
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppbarFromZero(
                    // TODO 1 show badge with number of open collections (different color with number of filterIncluding if any)
                    title: Text(
                      'Collections',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    actions: [
                      ActionFromZero(
                        title: 'Open Collection...',
                        icon: const Icon(Icons.create_new_folder),
                        onTap: (context) async {
                          final path = await FilePicker.platform.getDirectoryPath(
                            dialogTitle: 'Open Collection...',
                            lockParentWindow: true,
                          );
                          if (path != null) {
                            // TODO 2 show a warning that it will be created if it doesn't already exist,
                            // TODO 2 and validate that it isn't inside an existing collection
                            final collection = Collection(
                              name: p.basenameWithoutExtension(path),
                              baseDirectory: path,
                            );
                            // TODO 2 show a warning if it already exists, and don't save to db... right now it assumes it doesn't
                            CollectionProvider.addCollection(
                              ref,
                              collection,
                              saveToDb: true,
                            );
                            // TODO 2 show a warning if the collection couldn't be loaded
                          }
                        },
                      ),
                    ],
                  ),
                  if (collections.isEmpty) const ErrorSign(title: 'No collections registered...'),
                  if (collections.isNotEmpty)
                    ...collections.map((e) {
                      // TODO 3 implement excluding collections
                      // TODO 1 implement editing collection names
                      // TODO 3 implement removing collections, optionally deleting all its data as well (db, thumbnails, etc)
                      return CheckboxListTile(
                        value: includingCollections.contains(e),
                        controlAffinity: ListTileControlAffinity.leading,
                        dense: true,
                        title: Text(
                          e.name,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        onChanged: (value) {
                          if (value!) {
                            ref
                                .read(
                                  AppStateProvider.filterIncludingCollections.state,
                                )
                                .state = [
                              ...includingCollections,
                              e,
                            ];
                            CollectionProvider.saveCollectionToRecents(e);
                          } else {
                            ref
                                .read(
                                  AppStateProvider.filterIncludingCollections.state,
                                )
                                .state = List.from(includingCollections)
                              ..remove(e);
                          }
                        },
                      );
                    }),
                  if (collections.isNotEmpty) const SizedBox(height: 12),
                ],
              );
            },
          ),
          child: TextButton(
            child: Text(
              'Collections',
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
            showModalFromZero<dynamic>(
              context: context,
              builder: (context) {
                return DialogFromZero(
                  title: const Text('Scripts'),
                  contentPadding: EdgeInsets.zero,
                  maxWidth: 512,
                  dialogActions: const [
                    DialogButton.cancel(child: Text('CLOSE')),
                  ],
                  content: Column(
                    children: registeredScripts.map((e) {
                      return ListTile(
                        title: Text(e.name),
                        subtitle: Text(e.description),
                        onTap: () {
                          APISnackBar(
                            context: context,
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
          onTap: (context) {},
        ),
      ],
    );
  }
}
