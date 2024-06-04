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

  static final openItem = StateProvider<Item?>((ref) => null);

  static final filterIncludingTags = StateProvider((ref) => <Tag>[]);

  static final filterExcludingTags = StateProvider((ref) => <Tag>[]);

  static final filterIncludingCollections = StateProvider((ref) => <Collection>[]);

  static final filterExcludingCollections = StateProvider((ref) => <Collection>[]);

  static final filterRatingMin = StateProvider<int?>((ref) => null);
  static final filterRatingMax = StateProvider<int?>((ref) => null);

  static final filterExplorePriorityMin = StateProvider<int?>((ref) => null);
  static final filterExplorePriorityMax = StateProvider<int?>((ref) => null);

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
    final List<Item> result = collections.flatMap((e) => e.items).toList();
    final filterIncludingTags = ref.watch(AppStateProvider.filterIncludingTags);
    final filterExcludingTags = ref.watch(AppStateProvider.filterExcludingTags);
    final filterRatingMin = ref.watch(AppStateProvider.filterRatingMin);
    final filterRatingMax = ref.watch(AppStateProvider.filterRatingMax);
    final filterExplorePriorityMin = ref.watch(AppStateProvider.filterExplorePriorityMin);
    final filterExplorePriorityMax = ref.watch(AppStateProvider.filterExplorePriorityMax);
    if (filterIncludingTags.isNotEmpty) {
      result.removeWhere((e) => !e.tags.containsAll(filterIncludingTags));
    }
    if (filterExcludingTags.isNotEmpty) {
      result.removeWhere((e) => e.tags.containsAll(filterExcludingTags));
    }
    if (filterRatingMin!=null) {
      result.removeWhere((e) => e.rating!=null && e.rating! < filterRatingMin);
    }
    if (filterRatingMax!=null) {
      result.removeWhere((e) => e.rating!=null && e.rating! > filterRatingMax);
    }
    if (filterExplorePriorityMin!=null) {
      result.removeWhere((e) => e.explorePriority!=null && e.explorePriority! < filterExplorePriorityMin);
    }
    if (filterExplorePriorityMax!=null) {
      result.removeWhere((e) => e.explorePriority!=null && e.explorePriority! > filterExplorePriorityMax);
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