import 'package:collection_app/models/item.dart';
import 'package:collection_app/models/tag.dart';
import 'package:collection_app/providers/_isar_provider.dart';
import 'package:from_zero_ui/from_zero_ui.dart';
import 'package:isar/isar.dart';


abstract class ItemProvider {


  static final all = ApiProvider<List<Item>>((ref) {
    return ApiState(ref, (apiState) async {
      final collection = await apiState.watch(IsarProvider.openCollection);
      return await collection.items.where().findAll();
    });
  },
    cacheTime: const Duration(days: 999999999999),
  );


  static final withTags = ApiProviderFamily<List<Item>, Iterable<Tag>>((ref, tags) {
    return ApiState(ref, (apiState) async {
      final collection = await apiState.watch(IsarProvider.openCollection);
      final query = collection.items
          .where()
          .filter()
          .tags((q) => q.anyOf<Tag, Tag>(tags, (q, tag) => q.idEqualTo(tag.id)));
      return await query.findAll();
    });
  },
    disposeDelay: const Duration(seconds: 10),
  );


}