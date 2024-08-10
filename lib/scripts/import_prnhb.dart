import 'dart:io';
import 'package:collection_app/models/collection.dart';
import 'package:collection_app/models/item.dart';
import 'package:collection_app/models/tag.dart';
import 'package:collection_app/services/collection_service.dart';
import 'package:collection_app/services/item_service.dart';
import 'package:collection_app/services/tag_service.dart';
import 'package:collection_app/util/database.dart';
import 'package:collection_app/util/logging.dart';
import 'package:dartx/dartx_io.dart';
import 'package:from_zero_ui/from_zero_ui.dart';
import 'package:mlog/mlog.dart';
import 'package:path/path.dart' as p;
import 'package:resolve_windows_shortcut/resolve_windows_shortcut.dart';


// this doesn't work because some used parts need to import flutter (DBHelper for ValueNotifiers)
void main() async {
  importPrnhb();
  log(LgLvl.info,
    'Finished importing, saving Collections to DB...',
    type: LgType.script,
  );
  DbHelper.activeDbOperationsCount.addListener(() {
    if (DbHelper.activeDbOperationsCount.value%50==0) {
      log(LgLvl.finer,
        'Remaining DB operations: ${DbHelper.activeDbOperationsCount.value}',
        type: LgType.script,
      );
    }
  });
  log(LgLvl.info,
    'SUCCESS !!!',
    type: LgType.script,
  );
  await DbHelper.waitForAllDbOperationsToFinish(); // we don't actually need to await this, the app can keep working and execute all DB operations in the background
}



Future<void> importPrnhb({
  bool clearDb = true,
}) async {
  final addedDatetime = DateTime.now();
  final rootFolder = Directory(r'D:\Polnareff\prnhb');
  final collection = Collection(
    added: addedDatetime,
    name: 'Prnhb',
    baseDirectory: rootFolder.absolute.path,
  );
  if (clearDb) {
    await DbHelper.deleteDbForCollection(collection);
  }
  collectionService.addCollection(collection,
    checkIfAlreadyExists: false,
  );
  await DbHelper.waitForAllDbOperationsToFinish();
  final rootTagCreator = tagService.getTagByNameOrCreate(Tag(
    added: addedDatetime,
    name: 'Creator',
  ), collection,);
  final rootTagContent = tagService.getTagByNameOrCreate(Tag(
    added: addedDatetime,
    name: 'Content Tag',
  ), collection,);
  final unknownShortcutTag = tagService.getTagByNameOrCreate(Tag(
    added: addedDatetime,
    name: '!!! ATTENTION shortcut in unknown place during import',
  ), collection,);
  final Map<String, List<Tag>> addTagsToPathsAtTheEnd = {};
  _processFolder(rootFolder, [],
    collection: collection,
    addedDatetime: addedDatetime,
    rootTagCreator: rootTagCreator,
    rootTagContent: rootTagContent,
    unknownShortcutTag: unknownShortcutTag,
    addTagsToPathsAtTheEnd: addTagsToPathsAtTheEnd,
  );
  for (final entry in addTagsToPathsAtTheEnd.entries) {
    final item = collection.items.firstOrNullWhere((e) => e.getAbsoluteFilePath()==entry.key);
    if (item==null) {
      log(LgLvl.info,
        'Broken shortcut found to path: ${entry.key}'
            '\n    The following tags were assigned to it: ${entry.value.map((e) => e.name)}',
        type: LgType.script,
      );
    } else {
      // TODO 2 PERFORMANCE it will be faster if there was a way to add all items at once :)
      for (final tag in entry.value) {
        itemService.addTagToItem(item, tag);
      }
    }
  }
  log(LgLvl.info,
    'Successfully finished Prnhb Channels import process. Discovered:'
        '\n    ${collection.tags.length} Tags'
        '\n    ${collection.items.length} Items'
        '\ndb saving will be executed in the background...',
    type: LgType.script,
  );
  // TODO 3 PERFORMANCE it would be WAY more performant to not add the save operations individually, and instead save the entire collection as a single batch at the end
  // TODO 1 implement parsing rest of folders, including shortcuts in root and "/z - wait"
  return;
}



void _processFolder(Directory folder, List<Tag> tags, {
  required Collection collection,
  required Tag rootTagContent,
  required Tag rootTagCreator,
  required Tag unknownShortcutTag,
  required DateTime addedDatetime,
  required Map<String, List<Tag>> addTagsToPathsAtTheEnd,
  int? priority,
}) {
  final children = folder.listSync();
  for (final child in children) {
    final childName = child.nameWithoutExtension.trim();
    final childExtension = child.extension;
    final childAbsolutePath = child.absolute.path.trim();
    if (childName=='.collection_app') continue;
    if (child is Directory) {
      final parentName = child.parent.nameWithoutExtension.trim();
      int? childPriority;
      Tag? addedTag;
      if (parentName=='!channels') {
        StringBuffer creatorBuffer = StringBuffer('');
        StringBuffer tagBuffer = StringBuffer('');
        bool insideParenthesis = false;
        List<Tag> creatorTags = [];
        for (final char in childName.characters) {
          if (insideParenthesis) {
            if (char==')' || char==',') {
              final newTagName = tagBuffer.toString().trim();
              final newTag = tagService.getTagByNameOrCreate(Tag(
                name: newTagName,
                parentTag: rootTagContent,
              ), collection,);
              creatorTags.add(newTag);
              tagBuffer.clear();
              if (char==')') {
                insideParenthesis = false;
              }
            } else {
              tagBuffer.write(char);
            }
          } else {
            if (char=='(') {
              insideParenthesis = true;
            } else {
              creatorBuffer.write(char);
            }
          }
        }
        final creatorName = creatorBuffer.toString().trim();
        final creator = tagService.getTagByNameOrCreate(Tag(
          added: addedDatetime,
          name: creatorName,
          parentTag: rootTagCreator,
          secondaryParentTags: creatorTags,
        ), collection,);
        addedTag = creator;
      } else {
        if (childName=='rated' || childName=='!channels') {
          // do nothing
        } else if (childName=='!') {
          childPriority = 0;
        } else if (childName=='New folder' || childName=='Nueva carpeta') {
          childPriority = 1;
        } else if (childName=='New folder (2)' || childName=='Nueva carpeta (2)') {
          childPriority = 2;
        } else if (childName=='New folder (3)' || childName=='Nueva carpeta (3)') {
          childPriority = 3;
        } else {
          addedTag = tagService.getTagByNameOrCreate(Tag(
            name: childName,
            parentTag: rootTagContent,
          ), collection,);
        }
      }
      _processFolder(child, [...tags, if (addedTag!=null) addedTag],
        addedDatetime: addedDatetime,
        collection: collection,
        rootTagCreator: rootTagCreator,
        rootTagContent: rootTagContent,
        priority: childPriority ?? priority,
        unknownShortcutTag: unknownShortcutTag,
        addTagsToPathsAtTheEnd: addTagsToPathsAtTheEnd,
      );
    } else if (childExtension=='.lnk') {
      // shortcuts need to be processed last, to make sure the actual item is already created
      final resolvedShortcutPath = (child as File).resolveIfShortcutSync();
      // log (LgLvl.finer,
      //   'Resolved shortcut path for file: $childAbsolutePath\n    $resolvedShortcutPath',
      //   type: LgType.script,
      // );
      addTagsToPathsAtTheEnd[resolvedShortcutPath] ??= [];
      addTagsToPathsAtTheEnd[resolvedShortcutPath]!.add(unknownShortcutTag);
    } else {
      const allowedExtensions = ItemType.videoExtensions;
      if (!allowedExtensions.contains(childExtension)) {
        log (LgLvl.warning,
          'Unallowed extension found: $childExtension -- $childAbsolutePath',
          type: LgType.script,
        );
        continue;
      }
      final childRelativePath = p.relative(childAbsolutePath, from: collection.baseDirectory);
      var name = childName;
      int? rating;
      if (name.length>3 && name[0]=='(' && name[2]==')') {
        rating = int.tryParse(name[1]);
        if (rating!=null) name = name.substring(3);
      }
      if (name.length>4 && name[0]=='(' && name[2]=='+' && name[3]==')') {
        rating = int.tryParse(name[1]);
        if (rating!=null) name = name.substring(4);
      }
      if (rating!=null) {
        if (rating==6) {
          rating = 10;
        } else if (rating==5) {
          rating = 9;
        } else {
          rating *= 2;
        }
      }
      final newItem = Item(
        collection: collection,
        added: addedDatetime,
        name: name.trim(),
        filePath: childRelativePath,
        tags: tags,
        explorePriority: priority,
        rating: rating,
      );
      itemService.addItem(newItem,
        checkIfAlreadyExists: false,
      );
    }
  }
}
