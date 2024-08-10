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

  bool addItem(Item item, {
    bool checkIfAlreadyExists = true,
    bool saveToDb = true,
  }) {
    bool done = false;
    if (checkIfAlreadyExists) {
      if (!item.collection.items.contains(item)) {
        item.collection.items.add(item);
        done = true;
      }
    } else {
      item.collection.items.add(item);
      done = true;
    }
    if (done) {
      for (final tag in item.tags) {
        collectionService.addTagToCollection(item.collection, tag,
          saveToDb: saveToDb,
        );
      }
      if (saveToDb) {
        DbHelper.saveItem(item);
      }
    }
    return done;
  }

  bool saveItem(Item item, {
    bool replaceInList = false, /// usually not necessary, because we work by mutating the same object
    bool saveToDb = true,
  }) {
    if (replaceInList) {
      final index = item.collection.items.indexWhere((e) => e.id==item.id);
      if (index<0) throw Exception('Trying to save item, but item not found in Collection: $item');
    }
    if (saveToDb) {
      DbHelper.saveItem(item); // TODO 3 PERFORMANCE, in some cases (or all cases?), we can skip updating the relations in db (like tags)
    }
    return true;
  }

  bool addTagToItem(Item item, Tag tag, {
    bool checkIfAlreadyExists = true,
    bool saveToDb = true,
  }) {
    bool done = false;
    if (checkIfAlreadyExists) {
      if (!item.tags.contains(tag)) {
        item.tags.add(tag);
        done = true;
      }
    } else {
      item.tags.add(tag);
      done = true;
    }
    if (done) {
      collectionService.addTagToCollection(item.collection, tag,
        saveToDb: saveToDb,
      );
      if (saveToDb) {
        DbHelper.saveItem(item); // TODO 3 PERFORMANCE, save only item - tags relations
      }
    }
    return done;
  }

  bool addItemToAlbum(Item item, Item album, {
    bool checkIfAlreadyExists = true,
    bool saveToDb = true,
  }) {
    bool done = false;
    if (checkIfAlreadyExists) {
      if (!album.albumChildren!.contains(item)) {
        album.albumChildren!.add(item);
        item.albumParent = album;
        done = true;
      }
    } else {
      album.albumChildren!.add(item);
      item.albumParent = album;
      done = true;
    }
    if (done) {
      if (saveToDb) {
        DbHelper.saveItem(album); // TODO 3 PERFORMANCE, save only item - tags relations
      }
    }
    return done;
  }

}