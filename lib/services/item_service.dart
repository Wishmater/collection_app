import 'package:collection_app/models/collection.dart';
import 'package:collection_app/models/item.dart';
import 'package:collection_app/models/tag.dart';
import 'package:collection_app/services/collection_service.dart';
import 'package:collection_app/util/database.dart';
import 'package:dartx/dartx.dart';


final itemService = ItemService();

class ItemService {


  // GETS

  /// expensive, prefer to search per-collection ideally
  Iterable<Item> getAllItems() {
    return collectionService.getAllCollections().flatMap((e) => e.items);
  }

  List<Item> getItemsWithTag(Tag tag, {
    Collection? collection,
  }) {
    return getItemsWithTags([tag],
      collection: collection,
    );
  }

  List<Item> getItemsWithTags(Iterable<Tag> tags, {
    Collection? collection,
  }) {
    final items = collection?.items ?? getAllItems();
    return items.where((item) => tags.all((tag) => item.tags.contains(tag))).toList();
  }


  // MUTATIONS

  bool addItem(Collection collection, Item item, {
    bool checkIfAlreadyExists = true,
  }) {
    bool done = false;
    if (checkIfAlreadyExists) {
      if (!collection.items.contains(item)) {
        collection.items.add(item);
        done = true;
      }
      if (item.collection!=collection) {
        item.collection = collection;
        done = true;
      }
    } else {
      collection.items.add(item);
      item.collection = collection;
      done = true;
    }
    if (done) {
      for (final tag in item.tags) {
        collectionService.addTagToCollection(collection, tag);
      }
      DbHelper.saveItem(item);
    }
    return done;
  }

}