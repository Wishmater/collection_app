import 'package:collection_app/models/tag.dart';
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
  Tag getTagByNameOrCreate(Tag tag) {
    var result = getTagByName(tag.name);
    if (result==null) {
      result = tag;
      addTag(result);
    }
    return result;
  }


  // MUTATIONS

  bool addTag(Tag tag, {
    bool checkIfAlreadyExists = true,
  }) {
    if (checkIfAlreadyExists && _all.any((e) => e.name==tag.name)) {
      return false;
    }
    _all.add(tag);
    if (tag.parentTag!=null) {
      addChild(tag.parentTag!, tag);
    }
    addChildren(tag, tag.childTags);
    addSecondaryChildren(tag.secondaryParentTags, [tag]);
    addSecondaryChildren([tag], tag.secondaryChildTags);
    return true;
  }

  bool addChild(Tag parent, Tag child, {
    bool checkIfAlreadyExists = true,
  }) {
    if (checkIfAlreadyExists) {
      if (parent.childTags.contains(child)) return false;
      if (child.parentTag==parent) return false;
    }
    parent.childTags.add(child);
    child.parentTag = parent;
    return true;
  }

  bool addChildren(Tag parent, Iterable<Tag> children, {
    bool checkIfAlreadyExists = true,
  }) {
    if (checkIfAlreadyExists) {
      bool done = false;
      for (final child in children) {
        done = addChild(parent, child) || done;
      }
      return done;
    } else {
      parent.childTags.addAll(children);
      for (final child in children) {
        child.parentTag = parent;
      }
      return true;
    }
  }

  bool addSecondaryChild(Tag parent, Tag child, {
    bool checkIfAlreadyExists = true,
  }) {
    if (checkIfAlreadyExists) {
      if (parent.secondaryChildTags.contains(child)) return false;
      if (child.secondaryParentTags.contains(parent)) return false;
    }
    parent.secondaryChildTags.add(child);
    child.secondaryParentTags.add(parent);
    return true;
  }

  bool addSecondaryChildren(Iterable<Tag> parents, Iterable<Tag> children, {
    bool checkIfAlreadyExists = true,
  }) {
    if (checkIfAlreadyExists) {
      bool done = false;
      for (final parent in parents) {
        for (final child in children) {
          done = addSecondaryChild(parent, child) || done;;
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
      return true;
    }
  }

}