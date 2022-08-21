import 'package:collection_app/models/collection.dart';
import 'package:collection_app/providers/_isar_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:from_zero_ui/from_zero_ui.dart';
import 'package:hive/hive.dart';
import 'package:isar/isar.dart';


abstract class CollectionProvider {


  static final all = ApiProvider<List<CollectionData>>((ref) {
    return ApiState(ref, (apiState) async {
      final collections = await apiState.watch(IsarProvider.collections);
      return await collections.collectionDatas.where().findAll();
    });
  },
    cacheTime: const Duration(days: 999999999999),
  );

  static final openCollection = ApiProvider<CollectionData>((ref) {
    return ApiState(ref, (apiState) async {
      final selected = ref.watch(IsarProvider.selectedCollectionId)!;
      final isar = await apiState.watch(IsarProvider.collections);
      return (await isar.collectionDatas.get(selected))!;
    });
  },
    cacheTime: const Duration(days: 999999999999),
  );

  static ApiState<CollectionData> save(WidgetRef ref, CollectionData collection) {
    return ApiState.noProvider((apiState) async {
      final collections = await ref.watch(IsarProvider.collections.future);
      await collections.writeTxn(() async {
        collection.id = await collections.collectionDatas.put(collection);
      });
      return collection;
    });
  }


}