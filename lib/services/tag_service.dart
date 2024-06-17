import 'package:collection_app/models/collection.dart';
import 'package:collection_app/models/tag.dart';
import 'package:collection_app/services/collection_service.dart';
import 'package:collection_app/util/database.dart';
import 'package:dartx/dartx.dart';


final tagService = TagService();

class TagService {

  final List<Tag> _all = [];


  // GETS

  List<Tag> getAllTags() {
    return List.unmodifiable(_all);
  }

  Iterable<Tag> getRoots() {
    return _all.where((e) => e.parentTag==null);
  }

  Tag? getTagByName(String name) {
    return _all.firstOrNullWhere((e) => e.name==name);
  }

  /// the tag passed in will be used to check the name, or to create it if not found
  Tag getTagByNameOrCreate(Tag tag, Collection collection) {
    var result = getTagByName(tag.name);
    if (result==null) {
      result = tag;
      addTag(result, collection,
        checkIfAlreadyExists: false,
      );
    }
    return result;
  }


  // MUTATIONS

  bool addTag(Tag tag, Collection collection, {
    bool checkIfAlreadyExists = true,
  }) {
    if (checkIfAlreadyExists && _all.contains(tag)) {
      return false;
    }
    _all.add(tag);
    if (tag.parentTag!=null) {
      addChild(tag.parentTag!, tag,
        saveToDb: false,
      );
    }
    addChildren(tag, tag.childTags);
    addSecondaryChildren(tag.secondaryParentTags, [tag],
      saveToDb: false,
    );
    // TODO 2 PERFORMANCE, we could just save the new relations directly and call this with saveToDb: false
    addSecondaryChildren([tag], tag.secondaryChildTags);
    collectionService.addTagToCollection(collection, tag);
    return true;
  }

  bool addChild(Tag parent, Tag child, {
    bool checkIfAlreadyExists = true,
    bool saveToDb = true,
  }) {
    bool done = false;
    if (checkIfAlreadyExists) {
      if (!parent.childTags.contains(child)) {
        parent.childTags.add(child);
        done = true;
      }
      if (child.parentTag!=parent) {
        child.parentTag = parent;
        done = true;
      }
    } else {
      parent.childTags.add(child);
      child.parentTag = parent;
      done = true;
    }
    if (saveToDb && done) {
      // TODO 2 PERFORMANCE here we could just add the single child relation, instead of saving the entire tag
      DbHelper.saveTagToAllCollections(child);
    }
    return done;
  }

  bool addChildren(Tag parent, Iterable<Tag> children, {
    bool checkIfAlreadyExists = true,
    bool saveToDb = true,
  }) {
    if (checkIfAlreadyExists) {
      bool done = false;
      for (final child in children) {
        done = addChild(parent, child,
          saveToDb: saveToDb,
        ) || done;
      }
      return done;
    } else {
      parent.childTags.addAll(children);
      for (final child in children) {
        child.parentTag = parent;
      }
      if (saveToDb) {
        for (final child in children) {
          // TODO 2 PERFORMANCE here we could just add the single child relation, instead of saving the entire tag
          DbHelper.saveTagToAllCollections(child);
        }
      }
      return true;
    }
  }

  bool addSecondaryChild(Tag parent, Tag child, {
    bool checkIfAlreadyExists = true,
    bool saveToDb = true,
  }) {
    bool done = false;
    if (checkIfAlreadyExists) {
      if (!parent.secondaryChildTags.contains(child)) {
        parent.secondaryChildTags.add(child);
        done = true;
      }
      if (!child.secondaryParentTags.contains(parent)) {
        child.secondaryParentTags.add(parent);
        done = true;
      }
    } else {
      parent.secondaryChildTags.add(child);
      child.secondaryParentTags.add(parent);
      done = true;
    }
    if (saveToDb && done) {
      // TODO 2 PERFORMANCE here we could just add the single child relation, instead of saving the entire tag
      DbHelper.saveTagToAllCollections(child);
    }
    return done;
  }

  bool addSecondaryChildren(Iterable<Tag> parents, Iterable<Tag> children, {
    bool checkIfAlreadyExists = true,
    bool saveToDb = true,
  }) {
    if (checkIfAlreadyExists) {
      bool done = false;
      for (final parent in parents) {
        for (final child in children) {
          done = addSecondaryChild(parent, child,
            saveToDb: saveToDb,
          ) || done;
        }
      }
      return done;
    } else {
      for (final parent in parents) {
        parent.secondaryChildTags.addAll(children);
      }
      for (final child in children) {
        child.secondaryParentTags.addAll(parents);
      }
      if (saveToDb) {
        for (final child in children) {
          // TODO 2 PERFORMANCE here we could just add the single child relation, instead of saving the entire tag
          DbHelper.saveTagToAllCollections(child);
        }
      }
      return true;
    }
  }

}