import 'package:auto_size_text/auto_size_text.dart';
import 'package:collection_app/models/tag.dart';
import 'package:collection_app/providers/app_state_provider.dart';
import 'package:collection_app/widgets/utils/interval_rating_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:from_zero_ui/util/copied_flutter_widgets/my_tooltip.dart';


class FiltersWidget extends StatelessWidget {

  const FiltersWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.titleMedium!;
    return Padding(
      padding: const EdgeInsets.only(left: 12, right: 12, top: 4, bottom: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 6,),
          Consumer(
            builder: (context, ref, child) {
              final filterRatingMin = ref.watch(AppStateProvider.filterRatingMin);
              final filterRatingMax = ref.watch(AppStateProvider.filterRatingMax);
              final filterRatingNull = ref.watch(AppStateProvider.filterRatingNull);
              final color = Color.alphaBlend(Colors.yellow.withOpacity(0.6), Theme.of(context).canvasColor);
              return Wrap(
                children: [
                  const SizedBox(
                    width: 56,
                    child: Text('Rating:'),
                  ),
                  IntervalRatingBar(
                    min: 1, max: 10,
                    color: filterRatingNull ? Theme.of(context).disabledColor : color,
                    from: filterRatingMin, to: filterRatingMax,
                    onFromChanged: filterRatingNull ? null : (value) {
                      ref.read(AppStateProvider.filterRatingMin.notifier).state = value;
                    },
                    onToChanged: filterRatingNull ? null : (value) {
                      ref.read(AppStateProvider.filterRatingMax.notifier).state = value;
                    },
                    widgetBuilder: (context, value, {required selected, color}) {
                      return AnimatedContainer(
                        width: value==10 ? 24 : 18, height: 24,
                        duration: const Duration(milliseconds: 100),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: selected ? color!.withOpacity(color.opacity*0.6) : null,
                          borderRadius: BorderRadius.horizontal(
                            left: filterRatingMin==value ? const Radius.circular(6) : Radius.zero,
                            right: filterRatingMax==value ? const Radius.circular(6) : Radius.zero,
                          ),
                        ),
                        child: Text(value.toString(),
                          style: textStyle.copyWith(
                            fontWeight: FontWeight.w900,
                            color: selected
                                ? textStyle.color!.withOpacity(0.8)
                                : color,
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 12,),
                  InkWell(
                    onTap: () {
                      ref.read(AppStateProvider.filterRatingNull.notifier).state = !filterRatingNull;
                    },
                    child: AnimatedContainer(
                      width: 38, height: 24,
                      duration: const Duration(milliseconds: 100),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: filterRatingNull
                            ? color.withOpacity(color.opacity*0.6)
                            : null,
                        borderRadius: const BorderRadius.all(Radius.circular(6)),
                      ),
                      child: Text('null',
                        style: textStyle.copyWith(
                          fontWeight: FontWeight.w900,
                          color: filterRatingNull
                              ? textStyle.color!.withOpacity(0.8)
                              : color,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 4,),
          Consumer(
            builder: (context, ref, child) {
              final filterExplorePriorityMin = ref.watch(AppStateProvider.filterExplorePriorityMin);
              final filterExplorePriorityMax = ref.watch(AppStateProvider.filterExplorePriorityMax);
              final filterExplorePriorityNull = ref.watch(AppStateProvider.filterExplorePriorityNull);
              final color = Color.alphaBlend(Colors.purple.withOpacity(0.8), Theme.of(context).canvasColor);
              return Wrap(
                children: [
                  const SizedBox(
                    width: 56,
                    child: Text('Priority:'),
                  ),
                  IntervalRatingBar(
                    min: 0, max: 3,
                    color: filterExplorePriorityNull ? Theme.of(context).disabledColor : color,
                    from: filterExplorePriorityMin, to: filterExplorePriorityMax,
                    onFromChanged: filterExplorePriorityNull ? null : (value) {
                      ref.read(AppStateProvider.filterExplorePriorityMin.notifier).state = value;
                    },
                    onToChanged: filterExplorePriorityNull ? null : (value) {
                      ref.read(AppStateProvider.filterExplorePriorityMax.notifier).state = value;
                    },
                    widgetBuilder: (context, value, {required selected, color}) {
                      final textStyle = Theme.of(context).textTheme.titleMedium!;
                      return Container(
                        width: 20, height: 24,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: selected ? color!.withOpacity(color.opacity*0.6) : null,
                          borderRadius: BorderRadius.horizontal(
                            left: filterExplorePriorityMin==value ? const Radius.circular(6) : Radius.zero,
                            right: filterExplorePriorityMax==value ? const Radius.circular(6) : Radius.zero,
                          ),
                        ),
                        child: Text(value.toString(),
                          style: textStyle.copyWith(
                            fontWeight: FontWeight.w900,
                            color: selected
                                ? textStyle.color!.withOpacity(0.8)
                                : color,
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 12,),
                  InkWell(
                    onTap: () {
                      ref.read(AppStateProvider.filterExplorePriorityNull.notifier).state = !filterExplorePriorityNull;
                    },
                    child: AnimatedContainer(
                      width: 38, height: 24,
                      duration: const Duration(milliseconds: 100),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: filterExplorePriorityNull
                            ? color.withOpacity(color.opacity*0.6)
                            : null,
                        borderRadius: const BorderRadius.all(Radius.circular(6)),
                      ),
                      child: Text('null',
                        style: textStyle.copyWith(
                          fontWeight: FontWeight.w900,
                          color: filterExplorePriorityNull
                              ? textStyle.color!.withOpacity(0.8)
                              : color,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 2,),
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
              final filterIncludingTags = ref.watch(AppStateProvider.filterIncludingTags);
              final filterExcludingTags = ref.watch(AppStateProvider.filterExcludingTags);
              if (filterIncludingTags.isEmpty && filterExcludingTags.isEmpty) {
                return const SizedBox.shrink();
              }
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4,),
                  if (filterIncludingTags.isNotEmpty)
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      runAlignment: WrapAlignment.center,
                      children: [
                        Text('Including\nTags:',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            height: 1,
                            color: Color.alphaBlend(Colors.green.withOpacity(0.5), Theme.of(context).textTheme.bodyMedium!.color!,),
                          ),
                        ),
                        ...filterIncludingTags.map((e) => buildTagChip(context, ref, e, isIncluding: true)),
                      ],
                    ),
                  if (filterIncludingTags.isNotEmpty && filterExcludingTags.isNotEmpty)
                    const SizedBox(height: 8,),
                  if (filterExcludingTags.isNotEmpty)
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      runAlignment: WrapAlignment.center,
                      children: [
                        Text('Excluding\nTags:',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            height: 1,
                            color: Color.alphaBlend(Colors.red.withOpacity(0.5), Theme.of(context).textTheme.bodyMedium!.color!,),
                          ),
                        ),
                        ...filterExcludingTags.map((e) => buildTagChip(context, ref, e, isIncluding: false)),
                      ],
                    ),
                  const SizedBox(height: 4,),
                ],
              );
            },
          ),
          const SizedBox(height: 4,),
        ],
      ),
    );
  }

  Widget buildTagChip(BuildContext context, WidgetRef ref, Tag tag, {
    required bool isIncluding,
  }) {
    return Chip(
      deleteIconColor: Theme.of(context).iconTheme.color,
      label: AutoSizeText(tag.name,
        overflowReplacement: TooltipFromZero(
          message: tag.name,
          child: Text(tag.name),
        ),
      ),
      padding: EdgeInsets.zero,
      labelPadding: const EdgeInsets.only(left: 8),
      // deleteIcon: const Icon(Icons.close),
      deleteButtonTooltipMessage: '',
      onDeleted: () {
        final notifier = isIncluding
            ? ref.read(AppStateProvider.filterIncludingTags.notifier)
            : ref.read(AppStateProvider.filterExcludingTags.notifier);
        notifier.state = List.from(notifier.state..remove(tag));
      },
    );
  }

}
