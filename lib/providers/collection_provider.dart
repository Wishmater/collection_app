import 'package:collection_app/models/collection.dart';
import 'package:collection_app/services/collection_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


abstract class CollectionProvider {


  // PROVIDERS

  static final all = StateProvider((ref) {
    return collectionService.getAllCollections();
  });

  static final one = StateProviderFamily((ref, String name) {
    return collectionService.getAllCollections().firstWhere((e) => e.name==name);
  });


  // MUTATIONS

  void addCollection(WidgetRef ref, Collection collection, {
    bool checkIfAlreadyExists = true,
  }) {
    collectionService.addCollection(collection,
      checkIfAlreadyExists: checkIfAlreadyExists,
    );
    ref.invalidate(all);
  }

}