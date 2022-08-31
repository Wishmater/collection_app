import 'package:collection_app/models/tag.dart';
import 'package:collection_app/providers/_isar_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:from_zero_ui/from_zero_ui.dart';
import 'package:isar/isar.dart';


abstract class TagProvider {


  static final all = ApiProvider<List<Tag>>((ref) {
    return ApiState(ref, (apiState) async {
      final collection = await apiState.watch(IsarProvider.openCollection);
      return await collection.tags.where().findAll();
    });
  },
    cacheTime: const Duration(days: 999999999999),
  );


  static final roots = ApiProvider<List<Tag>>((ref) {
    return ApiState(ref, (apiState) async {
      final collection = await apiState.watch(IsarProvider.openCollection);
      return await collection.tags.filter().parentTagIsNull().findAll();
    });
  },
    cacheTime: const Duration(days: 999999999999),
  );


  static final one = ApiProviderFamily<Tag, int>((ref, id) {
    return ApiState(ref, (apiState) async {
      final collection = await apiState.watch(IsarProvider.openCollection);
      return (await collection.tags.where().idEqualTo(id).findFirst())!;
    });
  },
    cacheTime: const Duration(days: 999999999999),
  );


  static final children = ApiProviderFamily<List<Tag>, int>((ref, id) {
    return ApiState(ref, (apiState) async {
      final tag = await apiState.watch(one.call(id));
      await tag.childrenTags.load();
      return tag.childrenTags.toList();
    });
  },
    cacheTime: const Duration(days: 999999999999),
  );


  static final childrenCount = ApiProviderFamily<int, int>((ref, id) {
    return ApiState(ref, (apiState) async {
      final tag = await apiState.watch(one.call(id));
      return tag.childrenTags.count();
    });
  },
    cacheTime: const Duration(days: 999999999999),
  );


  static final hasChildren = ApiProviderFamily<bool, int>((ref, id) {
    return ApiState(ref, (apiState) async {
      final count = await apiState.watch(childrenCount.call(id));
      return count > 0;
    });
  },
    cacheTime: const Duration(days: 999999999999),
  );


  static ApiState<Tag> save(WidgetRef ref, Tag model) {
    return ApiState.noProvider((apiState) async {
      final collection = await ref.read(IsarProvider.openCollection.future);
      await collection.writeTxn(() async {
        model.id = await collection.tags.put(model);
        await model.parentTag.save();
      });
      return model;
    });
  }


  static ApiState<bool> delete(WidgetRef ref, Tag model) {
    return ApiState.noProvider((apiState) async {
      final collection = await ref.read(IsarProvider.openCollection.future);
      bool result = false;
      await collection.writeTxn(() async {
        result = await collection.tags.delete(model.id);
      });
      return result;
    });
  }


}