import 'package:collection_app/providers/app_state_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class FiltersWidget extends StatelessWidget {

  const FiltersWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Filters',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        Consumer(
          builder: (context, ref, child) {
            final filterIncludingTags = ref.watch(AppStateProvider.filterIncludingTags);
            final filterExcludingTags = ref.watch(AppStateProvider.filterExcludingTags);
            if (filterIncludingTags.isEmpty && filterExcludingTags.isEmpty) {
              return const SizedBox.shrink();
            }

            return Text('Tags');
          },
        ),
        Consumer(
          builder: (context, ref, child) {
            final filterIncludingCollections = ref.watch(AppStateProvider.filterIncludingCollections);
            final filterExcludingCollections = ref.watch(AppStateProvider.filterExcludingCollections);
            // TODO 2 implement including / excluding collections
            return const SizedBox.shrink();
          },
        ),
        Consumer(
          builder: (context, ref, child) {
            final filterRatingMin = ref.watch(AppStateProvider.filterRatingMin);
            final filterRatingMax = ref.watch(AppStateProvider.filterRatingMax);

            return Text('Rating');
          },
        ),
        Consumer(
          builder: (context, ref, child) {
            final filterExplorePriorityMin = ref.watch(AppStateProvider.filterExplorePriorityMin);
            final filterExplorePriorityMax = ref.watch(AppStateProvider.filterExplorePriorityMax);

            return Text('Explore Priority');
          },
        ),
      ],
    );
  }

}

