import 'package:collection_app/models/collection.dart';
import 'package:collection_app/models/item.dart';


final collectionService = CollectionService();

class CollectionService {

  final List<Collection> _all = [];


  // GETS

  List<Collection> getAllCollections() {
    return List.unmodifiable(_all);
  }


  // MUTATIONS

  bool addCollection(Collection collection, {
    bool checkIfAlreadyExists = true,
  }) {
    if (checkIfAlreadyExists && _all.any((e) => e.name==collection.name)) {
      return false;
    }
    _all.add(collection);
    return true;
  }

}