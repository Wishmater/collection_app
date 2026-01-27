import 'package:collection_app/models/collection.dart';
import 'package:collection_app/models/tag.dart';
import 'package:collection_app/services/tag_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class TagProvider {
  // PROVIDERS

  static final all = StateProvider((ref) {
    return tagService.getAllTags();
  });

  static final roots = StateProvider((ref) {
    return ref.watch(all).where((e) => e.parentTag == null);
  });

  static final one = StateProviderFamily((ref, String name) {
    return ref.watch(all).firstWhere((e) => e.name == name);
  });
  // TODO 1 do the same thing with streams we didi in items to update widgets that represent one collection

  // MUTATIONS

  bool addTag(
    WidgetRef ref,
    Tag tag,
    Collection collection, {
    bool checkIfAlreadyExists = true,
  }) {
    final added = tagService.addTag(
      tag,
      collection,
      checkIfAlreadyExists: checkIfAlreadyExists,
    );
    if (added) {
      ref.invalidate(all);
      if (tag.parentTag != null) {
        ref.invalidate(
          one.call(tag.parentTag!.name),
        ); // TODO 2 performance: this triggers the provider to re-search in the list of al items. Ideally we just notify listeners.
      }
      for (final e in tag.childTags) {
        ref.invalidate(
          one.call(e.name),
        ); // TODO 2 performance: this triggers the provider to re-search in the list of al items. Ideally we just notify listeners.
      }
      for (final e in tag.secondaryParentTags) {
        ref.invalidate(
          one.call(e.name),
        ); // TODO 2 performance: this triggers the provider to re-search in the list of al items. Ideally we just notify listeners.
      }
      for (final e in tag.secondaryChildTags) {
        ref.invalidate(
          one.call(e.name),
        ); // TODO 2 performance: this triggers the provider to re-search in the list of al items. Ideally we just notify listeners.
      }
    }
    return added;
  }

  bool addChild(
    WidgetRef ref,
    Tag parent,
    Tag child, {
    bool checkIfAlreadyExists = true,
  }) {
    final added = tagService.addChild(
      parent,
      child,
      checkIfAlreadyExists: checkIfAlreadyExists,
    );
    if (added) {
      ref.invalidate(
        one.call(parent.name),
      ); // TODO 2 performance: this triggers the provider to re-search in the list of al items. Ideally we just notify listeners.
      ref.invalidate(
        one.call(child.name),
      ); // TODO 2 performance: this triggers the provider to re-search in the list of al items. Ideally we just notify listeners.
    }
    return added;
  }

  bool addChildren(
    WidgetRef ref,
    Tag parent,
    Iterable<Tag> children, {
    bool checkIfAlreadyExists = true,
  }) {
    final added = tagService.addChildren(
      parent,
      children,
      checkIfAlreadyExists: checkIfAlreadyExists,
    );
    if (added) {
      ref.invalidate(
        one.call(parent.name),
      ); // TODO 2 performance: this triggers the provider to re-search in the list of al items. Ideally we just notify listeners.
      for (final e in children) {
        ref.invalidate(
          one.call(e.name),
        ); // TODO 2 performance: this triggers the provider to re-search in the list of al items. Ideally we just notify listeners.
      }
    }
    return added;
  }

  bool addSecondaryChild(
    WidgetRef ref,
    Tag parent,
    Tag child, {
    bool checkIfAlreadyExists = true,
  }) {
    final added = tagService.addSecondaryChild(
      parent,
      child,
      checkIfAlreadyExists: checkIfAlreadyExists,
    );
    if (added) {
      ref.invalidate(
        one.call(parent.name),
      ); // TODO 2 performance: this triggers the provider to re-search in the list of al items. Ideally we just notify listeners.
      ref.invalidate(
        one.call(child.name),
      ); // TODO 2 performance: this triggers the provider to re-search in the list of al items. Ideally we just notify listeners.
    }
    return added;
  }

  bool addSecondaryChildren(
    WidgetRef ref,
    Iterable<Tag> parents,
    Iterable<Tag> children, {
    bool checkIfAlreadyExists = true,
  }) {
    final added = tagService.addSecondaryChildren(
      parents,
      children,
      checkIfAlreadyExists: checkIfAlreadyExists,
    );
    if (added) {
      for (final e in parents) {
        ref.invalidate(
          one.call(e.name),
        ); // TODO 2 performance: this triggers the provider to re-search in the list of al items. Ideally we just notify listeners.
      }
      for (final e in children) {
        ref.invalidate(
          one.call(e.name),
        ); // TODO 2 performance: this triggers the provider to re-search in the list of al items. Ideally we just notify listeners.
      }
    }
    return added;
  }
}
