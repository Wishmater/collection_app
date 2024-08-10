import 'package:collection_app/models/collection.dart';
import 'package:collection_app/services/collection_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


abstract class CollectionProvider {


  // PROVIDERS

  static final all = StateProvider((ref) {
    return collectionService.getAllCollections();
  });

  static final one = StateProviderFamily((ref, String name) {
    return ref.watch(all).firstWhere((e) => e.name==name);
  });
  // TODO 1 do the same thing with streams we did in items to update widgets that represent one tag


  // MUTATIONS

  static void addCollection(WidgetRef ref, Collection collection, {
    bool checkIfAlreadyExists = true,
    bool saveToDb = true,
  }) {
    collectionService.addCollection(collection,
      checkIfAlreadyExists: checkIfAlreadyExists,
      saveToDb: false,
    );
    ref.invalidate(all);
  }

}