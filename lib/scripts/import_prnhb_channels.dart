import 'dart:io';
import 'package:collection_app/models/collection.dart';
import 'package:collection_app/models/item.dart';
import 'package:collection_app/models/tag.dart';
import 'package:collection_app/services/collection_service.dart';
import 'package:collection_app/services/item_service.dart';
import 'package:collection_app/services/tag_service.dart';
import 'package:dartx/dartx_io.dart';
import 'package:path/path.dart' as p;


void importPrnhbChannels() {
  final addedDatetime = DateTime.now();
  final rootFolder = Directory(r'D:\Polnareff\prnhb\!channels');
  final directChildren = rootFolder.listSync();
  final collection = Collection(
    added: addedDatetime,
    name: 'Prnhb Channels',
    baseDirectory: rootFolder.absolute.path,
  );
  collectionService.addCollection(collection,
    checkIfAlreadyExists: false,
  );
  final rootTagCreator = Tag(
    added: addedDatetime,
    name: 'Creator',
  );
  tagService.addTag(rootTagCreator,
    checkIfAlreadyExists: false,
  );
  final rootTagContent = Tag(
    added: addedDatetime,
    name: 'Content Tag',
  );
  tagService.addTag(rootTagContent,
    checkIfAlreadyExists: false,
  );
  for (final directChild in directChildren) {
    if (directChild is! Directory) continue;
    StringBuffer creatorBuffer = StringBuffer('');
    StringBuffer tagBuffer = StringBuffer('');
    bool insideParenthesis = false;
    List<Tag> creatorTags = [];
    for (final char in directChild.nameWithoutExtension.trim().characters) {
      if (insideParenthesis) {
        if (char==')' || char==',') {
          final newTagName = tagBuffer.toString().trim();
          final newTag = tagService.getTagByNameOrCreate(Tag(
            name: newTagName,
            parentTag: rootTagContent,
          ),);
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
    final creator = Tag(
      added: addedDatetime,
      name: creatorName,
      parentTag: rootTagCreator,
      secondaryParentTags: creatorTags,
    );
    tagService.addTag(creator,
      checkIfAlreadyExists: false,
    );
    _processSubfolder(directChild, [creator],
      collection: collection,
      addedDatetime: addedDatetime,
      rootTagContent: rootTagContent,
    );
  }
}


void _processSubfolder(Directory folder, List<Tag> tags, {
  required Collection collection,
  required Tag rootTagContent,
  required DateTime addedDatetime,
  int? priority,
}) {
  final children = folder.listSync();
  for (final child in children) {
    final childName = child.nameWithoutExtension.trim();
    final childExtension = child.extension;
    final childAbsolutePath = child.absolute.path.trim();
    if (child is Directory) {
      int? childPriority;
      Tag? addedTag;
      if (childName=='rated') {
        // nothing
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
        ),);
      }
      _processSubfolder(child, [...tags, if (addedTag!=null) addedTag],
        addedDatetime: addedDatetime,
        collection: collection,
        rootTagContent: rootTagContent,
        priority: childPriority ?? priority,
      );
    } else {
      const allowedExtensions = ['.mkv', '.mp4', '.mpg', '.mpeg', '.avi'];
      if (!allowedExtensions.contains(childExtension)) {
        print ('Warning: Unallowed extension found: $childExtension -- $childAbsolutePath');
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
      final newItem = Item(
        added: addedDatetime,
        name: name.trim(),
        filePath: childRelativePath,
        tags: tags,
        explorePriority: priority,
        rating: rating,
      );
      itemService.addItem(collection, newItem,
        checkIfAlreadyExists: false,
      );
    }
  }
}
