import 'package:collection_app/models/collection.dart';
import 'package:collection_app/models/item.dart';
import 'package:collection_app/models/tag.dart';
import 'package:collection_app/services/collection_service.dart';
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
    return items.where((item) => tags.all((tag) => item.tags.any((e) => e==tag))).toList();
  }


  // MUTATIONS

  bool addItem(Collection collection, Item item, {
    bool checkIfAlreadyExists = true,
  }) {
    // TODO 1 how to uniquely identify an item ??
    // if (checkIfAlreadyExists && getAllItems().any((e) => e.name==item.name)) {
    //   return false;
    // }
    collection.items.add(item);
    return true;
  }

}