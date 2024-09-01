import 'dart:async';

import 'package:collection_app/models/collection.dart';
import 'package:collection_app/models/item.dart';
import 'package:collection_app/models/tag.dart';
import 'package:collection_app/providers/collection_provider.dart';
import 'package:collection_app/providers/tag_provider.dart';
import 'package:collection_app/services/item_service.dart';
import 'package:collection_app/util/any_ref.dart';
import 'package:dartx/dartx.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


abstract class ItemProvider {


  // PROVIDERS

  /// expensive, prefer to search per-collection ideally
  static final all = StateProvider((ref) {
    return ref.watch(CollectionProvider.all).flatMap((e) => e.items);
  });

  static final one = StateProvider.family((ref, (Collection collection, int id) param) {
    return param.$1.items.firstWhere((e) => e.id==param.$2);
  });
  static void invalidateOne(AnyRef ref, Item item) {
    ref.invalidate(one.call((item.collection, item.id))); // TODO 2 PERFORMANCE: this triggers the provider to re-search the item list. Ideally we just notify listeners if replaceInList==false.
    _updatedItemIdsStreamController.add(item);
  }
  static final StreamController<Item> _updatedItemIdsStreamController = StreamController.broadcast();
  static Stream<Item> get updatedItemIdsStream => _updatedItemIdsStreamController.stream;


  // MUTATIONS

  static bool addItem(Ref ref, Item item, {
    bool checkIfAlreadyExists = true,
  }) {
    final added = itemService.addItem(item,
      checkIfAlreadyExists: checkIfAlreadyExists,
    );
    if (added) {
      ref.invalidate(all);
      ref.invalidate(CollectionProvider.one.call(item.collection.name)); // TODO 2 PERFORMANCE: this triggers the provider to re-search in the list of all items. Ideally we just notify listeners.
    }
    return added;
  }

  static bool saveItem(AnyRef ref, Item item, {
    bool replaceInList = false, /// usually not necessary, because we work by mutating the same object
  }) {
    final saved = itemService.saveItem(item,
      replaceInList: false,
    );
    if (saved) {
      invalidateOne(ref, item);
    }
    return true;
  }

  static bool addTagToItem(AnyRef ref, Item item, Tag tag, {
    bool checkIfAlreadyExists = true,
  }) {
    final added = itemService.addTagToItem(item, tag,
      checkIfAlreadyExists: checkIfAlreadyExists,
      saveToDb: true,
    );
    if (added) {
      invalidateOne(ref, item);
      ref.invalidate(TagProvider.one.call(tag.name)); // TODO 2 performance: this triggers the provider to re-search in the list of al items. Ideally we just notify listeners.
    }
    return added;
  }

  static bool addItemToAlbum(AnyRef ref, Item item, Item album, {
    bool checkIfAlreadyExists = true,
  }) {
    final added = itemService.addItemToAlbum(item, album,
      checkIfAlreadyExists: checkIfAlreadyExists,
      saveToDb: true,
    );
    if (added) {
      invalidateOne(ref, item);
      invalidateOne(ref, album);
    }
    return added;
  }

}
