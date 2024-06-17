import 'package:collection_app/models/collection.dart';
import 'package:collection_app/models/item.dart';
import 'package:collection_app/providers/collection_provider.dart';
import 'package:collection_app/services/item_service.dart';
import 'package:dartx/dartx.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


abstract class ItemProvider {


  // PROVIDERS

  /// expensive, prefer to search per-collection ideally
  static final all = StateProvider((ref) {
    return ref.watch(CollectionProvider.all).flatMap((e) => e.items);
  });


  // MUTATIONS

  bool addItem(WidgetRef ref, Item item, {
    bool checkIfAlreadyExists = true,
  }) {
    final added = itemService.addItem(item,
      checkIfAlreadyExists: checkIfAlreadyExists,
    );
    if (added) {
      ref.invalidate(all);
      ref.invalidate(CollectionProvider.one.call(item.collection.name)); // TODO 2 performance: this triggers the provider to re-search in the list of al items. Ideally we just notify listeners.
    }
    return added;
  }

}