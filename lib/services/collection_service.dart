import 'package:collection_app/models/collection.dart';
import 'package:collection_app/models/tag.dart';
import 'package:collection_app/util/database_helper.dart';
import 'package:collection_app/util/persistence.dart';
import 'package:from_zero_ui/from_zero_ui.dart';
import 'package:hive/hive.dart';
import 'package:mlog/mlog.dart';

final collectionService = CollectionService();

class CollectionService {
  final List<Collection> _all = []; // PERF: 2 maybe create a map from ID(name) to collection for faster search

  // GETS

  List<Collection> getAllCollections() {
    return List.unmodifiable(_all);
  }

  // MUTATIONS

  bool addCollection(
    Collection collection, {
    bool checkIfAlreadyExists = true,
    bool saveToDb = true,
  }) {
    if (checkIfAlreadyExists && _all.contains(collection)) {
      return false;
    }
    _all.add(collection);
    Future<void> execute() async {
      try {
        await DbHelper.openDbForCollection(collection);
      } catch (e, st) {
        log(
          LgLvl.error,
          'Error while opening collection ${collection.name} from path ${collection.baseDirectory}',
          e: e,
          st: st,
        );
        removeCollection(collection);
        // TODO: 2 remove collection that errored from recent?
      }
      if (saveToDb) {
        Persistence.saveCollection(collection);
        saveCollectionToRecents(collection);
      }
    }

    execute();
    return true;
  }

  void saveCollectionToRecents(Collection collection) {
    final box = Hive.box<List<dynamic>>('collections');
    box.put(collection.baseDirectory, [collection.name, DateTime.now()]);
  }

  bool removeCollection(Collection collection) {
    final index = _all.indexOf(collection);
    if (index < 0) return false;
    DbHelper.closeDbForCollection(collection);
    _all.removeAt(index);
    return true;
  }

  bool addTagToCollection(
    Collection collection,
    Tag tag, {
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
