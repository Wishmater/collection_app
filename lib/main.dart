import 'package:collection_app/models/item.dart';
import 'package:collection_app/models/tag.dart';
import 'package:collection_app/scripts/import_prnhb_channels.dart';
import 'package:collection_app/services/collection_service.dart';
import 'package:collection_app/services/item_service.dart';
import 'package:collection_app/services/tag_service.dart';
import 'package:flutter/material.dart';
import 'package:from_zero_ui/from_zero_ui.dart';
import 'package:url_launcher/url_launcher.dart';


void main() {
  importPrnhbChannels();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      themeMode: ThemeMode.dark,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const TempExploreWidget(),
    );
  }
}


class TempExploreWidget extends StatefulWidget {

  const TempExploreWidget({super.key});

  @override
  State<TempExploreWidget> createState() => _TempExploreWidgetState();

}

class _TempExploreWidgetState extends State<TempExploreWidget> {

  final ValueNotifier<Tag?> selectedTag = ValueNotifier(null);

  @override
  Widget build(BuildContext context) {
    final leftScrollController = ScrollController();
    final rightScrollController = ScrollController();
    return Scaffold(
      body: Row(
        children: [
          Expanded(
            child: ScrollbarFromZero(
              controller: leftScrollController,
              child: ListView.builder(
                controller: leftScrollController,
                itemCount: tagService.getAllTags().length,
                itemBuilder: (context, index) {
                  final tag = tagService.getAllTags()[index];
                  return ListTile(
                    title: Text(tag.name),
                    subtitle: Text('${tag.parentTag} -- ${tag.secondaryParentTags.map((e) => e.name).join('; ')}'),
                    onTap: () {
                      selectedTag.value = tag;
                    },
                  );
                },
              ),
            ),
          ),
          const SizedBox(width: 32,),
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: selectedTag,
              builder: (context, selectedTag, child) {
                final items = selectedTag==null
                    ? itemService.getAllItems().toList()
                    : itemService.getItemsWithTag(selectedTag);
                return ScrollbarFromZero(
                  controller: rightScrollController,
                  child: ListView.builder(
                    controller: rightScrollController,
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      var text = item.tags.map((e) => e.name).join('; ');
                      if (item.explorePriority!=null) text = '[${item.explorePriority}] $text';
                      if (item.rating!=null) text = '(${item.rating}) $text';
                      return ListTile(
                        title: Text(item.name),
                        subtitle: Text(text),
                        onTap: () {
                          // maybe show item details ?
                          final filePath = item.getAbsoluteFilePathForItem(collectionService.getAllCollections().first);
                          if (filePath!=null) {
                            launch(filePath);
                          }
                        },
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

}
