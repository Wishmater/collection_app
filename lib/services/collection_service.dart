import 'package:collection_app/models/collection.dart';
import 'package:collection_app/models/tag.dart';
import 'package:collection_app/util/persistence.dart';
import 'package:collection_app/util/database_helper.dart';
import 'package:hive/hive.dart';


final collectionService = CollectionService();

class CollectionService {

  final List<Collection> _all = []; // TODO 2 PERFORMANCE maybe create a map from ID(name) to collection for faster search


  // GETS

  List<Collection> getAllCollections() {
    return List.unmodifiable(_all);
  }


  // MUTATIONS

  bool addCollection(Collection collection, {
    bool checkIfAlreadyExists = true,
    bool saveToDb = true,
  }) {
    if (checkIfAlreadyExists && _all.contains(collection)) {
      return false;
    }
    _all.add(collection);
    DbHelper.openDbForCollection(collection).then((_) {
      if (saveToDb) {
        Persistence.saveCollection(collection);
        saveCollectionToRecents(collection);
      }
    });
    return true;
  }

  void saveCollectionToRecents(Collection collection) {
    final box = Hive.box<List<dynamic>>('collections');
    box.put(collection.baseDirectory, [collection.name, DateTime.now()]);
  }

  bool removeCollection(Collection collection) {
    final index = _all.indexOf(collection);
    if (index<0) return false;
    DbHelper.closeDbForCollection(collection);
    _all.removeAt(index);
    return true;
  }

  bool addTagToCollection(Collection collection, Tag tag, {
    bool checkIfAlreadyExists = true,
    bool saveToDb = true,
  }) {
    if (checkIfAlreadyExists && collection.tags.contains(tag)) {
      return false;
    }
    collection.tags.add(tag);
    if (saveToDb) {
      Persistence.saveTagToCollection(tag, collection);
    }
    return true;
  }

}