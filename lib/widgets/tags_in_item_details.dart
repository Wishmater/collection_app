import 'package:collection_app/models/tag.dart';
import 'package:collection_app/providers/tag_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:from_zero_ui/from_zero_ui.dart';

class TagChip extends StatelessWidget {
  final Tag tag;
  final VoidCallback onRemove;

  const TagChip({
    required this.tag,
    required this.onRemove,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onSecondaryTap: onRemove,
      onTertiaryTapDown: (_) => onRemove(),
      child: Chip(
        label: Text(tag.name),
        visualDensity: VisualDensity.compact,
      ),
    );
  }
}

class AddTagButton extends ConsumerStatefulWidget {
  final void Function(Tag tag) onTagSelected;
  final void Function(String name) onTagCreated;
  final List<Tag> excludedTags;

  const AddTagButton({
    required this.onTagSelected,
    required this.onTagCreated,
    required this.excludedTags,
    super.key,
  });

  @override
  ConsumerState<AddTagButton> createState() => AddTagButtonState();
}

class AddTagButtonState extends ConsumerState<AddTagButton> {
  final GlobalKey _buttonKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        key: _buttonKey,
        borderRadius: BorderRadius.circular(16),
        onTap: () => _showTagPopup(context),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            border: Border.all(color: Theme.of(context).dividerColor),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.add,
                size: 16,
                color: Theme.of(context).textTheme.bodySmall?.color,
              ),
              const SizedBox(width: 4),
              Text(
                'Add',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showTagPopup(BuildContext context) async {
    final RenderBox? renderBox = _buttonKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;
    final position = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;

    await showPopupFromZero<void>(
      context: context,
      referencePosition: position,
      referenceSize: size,
      anchorAlignment: Alignment.topCenter,
      popupAlignment: Alignment.bottomCenter,
      barrierColor: Colors.black.withValues(alpha: 0.1),
      builder: (context) => TagSearchPopup(
        onTagSelected: widget.onTagSelected,
        onTagCreated: widget.onTagCreated,
        excludedTags: widget.excludedTags,
      ),
    );
  }
}

class TagSearchPopup extends ConsumerStatefulWidget {
  final void Function(Tag tag) onTagSelected;
  final void Function(String name) onTagCreated;
  final List<Tag> excludedTags;

  const TagSearchPopup({
    required this.onTagSelected,
    required this.onTagCreated,
    required this.excludedTags,
    super.key,
  });

  @override
  ConsumerState<TagSearchPopup> createState() => TagSearchPopupState();
}

sealed class _ListItem {}

class _TagListItem extends _ListItem {
  final Tag tag;
  _TagListItem(this.tag);
}

class _CreateListItem extends _ListItem {
  final String name;
  _CreateListItem(this.name);
}

class TagSearchPopupState extends ConsumerState<TagSearchPopup> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final FocusNode _listFocusNode = FocusNode();
  bool _awaitingConfirmation = false;
  List<Tag> _filteredTags = [];
  int _focusedIndex = 0;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onTextChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    _listFocusNode.dispose();
    super.dispose();
  }

  String? lastQuery;
  void _onTextChanged() {
    final query = _controller.text.toLowerCase();
    if (lastQuery == query) return;
    lastQuery = query;
    final allTags = ref.read(TagProvider.all);
    final excludedNames = widget.excludedTags.map((t) => t.name).toSet();
    setState(() {
      _awaitingConfirmation = false;
      _filteredTags =
          allTags.where((tag) => !excludedNames.contains(tag.name) && tag.name.toLowerCase().contains(query)).toList()
            ..sort((a, b) => a.name.compareTo(b.name));
      _focusedIndex = 0;
    });
  }

  List<_ListItem> get _listItems {
    final items = _filteredTags.map<_ListItem>(_TagListItem.new);
    final query = _controller.text;
    final hasExactMatch = _filteredTags.any(
      (tag) => tag.name.toLowerCase() == query.toLowerCase(),
    );
    if (query.isNotEmpty && !hasExactMatch) {
      return [...items, _CreateListItem(query)];
    }
    return items.toList();
  }

  void _handleKeyEvent(KeyEvent event) {
    if (event is! KeyDownEvent) return;

    final items = _listItems;
    if (items.isEmpty) return;

    if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
      setState(() {
        _focusedIndex = (_focusedIndex + 1) % items.length;
      });
    } else if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
      setState(() {
        _focusedIndex = (_focusedIndex - 1 + items.length) % items.length;
      });
    }
  }

  void _selectItem(_ListItem item) {
    if (item is _TagListItem) {
      widget.onTagSelected(item.tag);
      Navigator.of(context).pop();
    } else if (item is _CreateListItem) {
      final query = _controller.text;
      if (query.isEmpty) {
        return;
      } else if (_awaitingConfirmation) {
        widget.onTagCreated(item.name);
        Navigator.of(context).pop();
      } else {
        setState(() {
          _awaitingConfirmation = true;
        });
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _focusNode.requestFocus();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final query = _controller.text;
    final items = _listItems;
    return KeyboardListener(
      focusNode: _listFocusNode,
      onKeyEvent: _handleKeyEvent,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 300, maxWidth: 250),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: TextField(
                controller: _controller,
                focusNode: _focusNode,
                decoration: InputDecoration(
                  hintText: 'Search or create tag...',
                  border: const OutlineInputBorder(),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  isDense: true,
                  suffixIcon: _awaitingConfirmation ? const Icon(Icons.warning_amber, color: Colors.orange) : null,
                ),
                onSubmitted: _handleSubmit,
              ),
            ),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  return switch (item) {
                    _CreateListItem() => ListTile(
                      dense: true,
                      selected: _focusedIndex == index,
                      selectedTileColor: Theme.of(context).hoverColor,
                      leading: Icon(
                        _awaitingConfirmation ? Icons.warning : Icons.add,
                        color: _awaitingConfirmation ? Colors.orange : null,
                      ),
                      title: Text(
                        _awaitingConfirmation ? 'Press Enter again to create "$query"' : 'Create "$query"',
                        style: TextStyle(
                          color: _awaitingConfirmation ? Colors.orange : null,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      onTap: () => _selectItem(_CreateListItem(query)),
                    ),
                    _TagListItem() => ListTile(
                      dense: true,
                      selected: _focusedIndex == index,
                      selectedTileColor: Theme.of(context).hoverColor,
                      title: Text(item.tag.name),
                      onTap: () => _selectItem(_TagListItem(item.tag)),
                    ),
                  };
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleSubmit(String value) {
    _selectItem(_listItems[_focusedIndex]);
  }
}
