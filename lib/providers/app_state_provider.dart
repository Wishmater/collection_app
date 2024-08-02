import 'package:collection_app/models/collection.dart';
import 'package:collection_app/models/item.dart';
import 'package:collection_app/models/tag.dart';
import 'package:collection_app/providers/collection_provider.dart';
import 'package:collection_app/providers/item_provider.dart';
import 'package:dartx/dartx_io.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


abstract class AppStateProvider {

  static const mainPageMinColumnWidth = 256.0;


  static final tagsColumnWidth = StateNotifierProvider<LimitingNumStateNotifier<double>, double>((ref) {
    return LimitingNumStateNotifier<double>(330, min: mainPageMinColumnWidth);
  });

  static final showItemViewInMainPage = StateProvider((ref) => false);

  static final itemsColumnWidth = StateNotifierProvider<LimitingNumStateNotifier<double>, double>((ref) {
    return LimitingNumStateNotifier<double>(330, min: mainPageMinColumnWidth);
  });

  static final selectedTag = StateProvider<Tag?>((ref) => null);

  static final selectedItem = StateProvider<Item?>((ref) => null);

  static final filterIncludingTags = StateProvider((ref) => <Tag>[]);

  static final filterExcludingTags = StateProvider((ref) => <Tag>[]);

  static final filterIncludingCollections = StateProvider((ref) => <Collection>[]);

  static final filterExcludingCollections = StateProvider((ref) => <Collection>[]);

  static final filterRatingNull = StateProvider<bool>((ref) => false);
  static final filterRatingMin = StateProvider<int?>((ref) => null);
  static final filterRatingMax = StateProvider<int?>((ref) => null);

  static final filterExplorePriorityNull = StateProvider<bool>((ref) => false);
  static final filterExplorePriorityMin = StateProvider<int?>((ref) => null);
  static final filterExplorePriorityMax = StateProvider<int?>((ref) => null);

  static final itemSearchQuery = StateProvider<String?>((ref) => null);

  static final itemsWithCurrentFilters = StateProvider((ref) {
    final filterIncludingCollections = ref.watch(AppStateProvider.filterIncludingCollections);
    final List<Collection> collections = filterIncludingCollections.isNotEmpty
        ? filterIncludingCollections
        : ref.watch(CollectionProvider.all);
    final filterExcludingCollections = ref.watch(AppStateProvider.filterExcludingCollections);
    for (final e in filterExcludingCollections) {
      collections.remove(e);
    }
    for (final e in collections) {
      ref.watch(CollectionProvider.one(e.name));
    }
    final List<Item> result = [];
    final filterIncludingTags = ref.watch(AppStateProvider.filterIncludingTags);
    final filterExcludingTags = ref.watch(AppStateProvider.filterExcludingTags);
    final filterRatingNull = ref.watch(AppStateProvider.filterRatingNull);
    final filterRatingMin = ref.watch(AppStateProvider.filterRatingMin);
    final filterRatingMax = ref.watch(AppStateProvider.filterRatingMax);
    final filterExplorePriorityNull = ref.watch(AppStateProvider.filterExplorePriorityNull);
    final filterExplorePriorityMin = ref.watch(AppStateProvider.filterExplorePriorityMin);
    final filterExplorePriorityMax = ref.watch(AppStateProvider.filterExplorePriorityMax);
    final itemSearchQuery = ref.watch(AppStateProvider.itemSearchQuery)?.toLowerCase();
    for (final e in collections.flatMap((e) => e.items)) {
      if (filterIncludingTags.isNotEmpty && !e.tags.containsAll(filterIncludingTags)) {
        continue;
      }
      if (filterExcludingTags.isNotEmpty && e.tags.containsAny(filterExcludingTags)) {
        continue;
      }
      if (filterRatingNull) {
        if (e.rating!=null) {
          continue;
        }
      } else {
        if (filterRatingMin!=null && (e.rating==null || e.rating! < filterRatingMin)) {
          continue;
        }
        if (filterRatingMax!=null && (e.rating==null || e.rating! > filterRatingMax)) {
          continue;
        }
      }
      if (filterExplorePriorityNull) {
        if (e.explorePriority!=null) {
          continue;
        }
      } else {
        if (filterExplorePriorityMin!=null
            && (e.explorePriority==null || e.explorePriority! < filterExplorePriorityMin)) {
          continue;
        }
        if (filterExplorePriorityMax!=null
            && (e.explorePriority==null || e.explorePriority! > filterExplorePriorityMax)) {
          continue;
        }
      }
      if (itemSearchQuery!=null && !e.name.toLowerCase().contains(itemSearchQuery)) {
        continue;
      }
      result.add(e);
    }
    return result;
  });

}



class LimitingNumStateNotifier<T extends num> extends StateNotifier<T> {

  final T? min;
  final T? max;

  LimitingNumStateNotifier(super._state, {
    this.min,
    this.max,
  });

  @override
  set state(T value) {
    if (min!=null && value<min!) value = min!;
    if (max!=null && value>max!) value = max!;
    super.state = value;
  }

  void setState(T value) => state = value;

  void add(T value) => state = (state + value) as T;

}