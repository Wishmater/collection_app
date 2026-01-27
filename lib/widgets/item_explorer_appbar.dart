import 'package:collection_app/providers/app_state_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:from_zero_ui/from_zero_ui.dart';
import 'package:intl/intl.dart';

class ItemExplorerAppbar extends ConsumerWidget {
  static const toolbarHeight = 46.0;

  const ItemExplorerAppbar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(AppStateProvider.itemsWithCurrentFilters);
    return AppbarFromZero(
      toolbarHeight: toolbarHeight,
      backgroundColor: Theme.of(context).canvasColor.withValues(alpha: 0.7),
      title: Text(
        '${NumberFormat.decimalPattern().format(items.length)} items',
        style: Theme.of(context).textTheme.titleSmall,
      ),
      actions: [
        ActionFromZero(
          title: 'Search items',
          icon: const Icon(Icons.search),
          centerExpanded: false,
          expandedBuilder:
              ({
                required context,
                required title,
                color,
                disablingError,
                icon,
                onTap,
              }) {
                return Align(
                  alignment: Alignment.centerRight,
                  child: SizedBox(
                    width: 256,
                    child: TextFormField(
                      initialValue: ref.read(AppStateProvider.itemSearchQuery),
                      decoration: InputDecoration(
                        isDense: true,
                        labelText: 'Search',
                        floatingLabelStyle: TextStyle(
                          height: 0.5,
                          color: Theme.of(context).iconTheme.color,
                        ),
                        labelStyle: TextStyle(
                          color: Theme.of(context).iconTheme.color,
                        ),
                        suffixIcon: Icon(
                          Icons.search,
                          size: 24,
                          color: Theme.of(context).iconTheme.color,
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.only(bottom: 4),
                      ),
                      onChanged: (value) {
                        ref.read(AppStateProvider.itemSearchQuery.notifier).state = value;
                      },
                    ),
                  ),
                );
              },
        ),
      ],
    );
  }
}
