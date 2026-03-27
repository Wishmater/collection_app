import 'dart:io';

import 'package:collection_app/models/collection.dart';
import 'package:collection_app/models/item.dart';
import 'package:collection_app/providers/item_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:from_zero_ui/from_zero_ui.dart';
import 'package:path/path.dart' as p;

class FileEntry {
  final String name;
  final String path;
  final String relativePath;
  final int size;
  DirectoryEntry? parent;

  FileEntry({
    required this.name,
    required this.path,
    required this.relativePath,
    required this.size,
    this.parent,
  });

  String get displaySize {
    if (size < 1024) return '$size B';
    if (size < 1024 * 1024) return '${(size / 1024).toStringAsFixed(1)} KB';
    if (size < 1024 * 1024 * 1024) return '${(size / (1024 * 1024)).toStringAsFixed(1)} MB';
    return '${(size / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }
}

class DirectoryEntry extends FileEntry {
  List<FileEntry> children;
  bool expanded;

  DirectoryEntry({
    required super.name,
    required super.path,
    required super.relativePath,
    required super.size,
    super.parent,
    List<FileEntry>? children,
    this.expanded = true,
  }) : children = children ?? [];

  Set<String> getAllDescendantPaths() {
    final paths = <String>{path};
    for (final child in children) {
      if (child is DirectoryEntry) {
        paths.addAll(child.getAllDescendantPaths());
      } else {
        paths.add(child.path);
      }
    }
    return paths;
  }

  void expandRecursively() {
    expanded = true;
    for (final child in children) {
      if (child is DirectoryEntry) {
        child.expandRecursively();
      }
    }
  }

  void collapseRecursively() {
    expanded = false;
    for (final child in children) {
      if (child is DirectoryEntry) {
        child.collapseRecursively();
      }
    }
  }
}

class AddItemDialog extends ConsumerStatefulWidget {
  final Collection collection;

  const AddItemDialog({
    required this.collection,
    super.key,
  });

  @override
  ConsumerState<AddItemDialog> createState() => _AddItemDialogState();
}

class _AddItemDialogState extends ConsumerState<AddItemDialog> {
  final List<FileEntry> _entries = [];
  bool _isLoading = false;

  Future<void> _addFiles() async {
    final result = await FilePicker.platform.pickFiles(
      initialDirectory: widget.collection.baseDirectory,
      allowMultiple: true,
      dialogTitle: 'Select files',
    );

    if (!mounted) return;

    if (result != null && result.files.isNotEmpty) {
      setState(() => _isLoading = true);

      for (final file in result.files) {
        final filePath = file.path;
        if (filePath != null) {
          final relativePath = p.relative(filePath, from: widget.collection.baseDirectory);
          final stat = await File(filePath).stat();
          _entries.add(
            FileEntry(
              name: file.name,
              path: filePath,
              relativePath: relativePath,
              size: stat.size,
            ),
          );
        }
      }

      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _addDirectory() async {
    final dirPath = await FilePicker.platform.getDirectoryPath(
      dialogTitle: 'Select directory',
      initialDirectory: widget.collection.baseDirectory,
    );

    if (!mounted) return;

    if (dirPath != null) {
      setState(() => _isLoading = true);

      final rootEntry = await _buildDirectoryTree(dirPath, null);
      _entries.add(rootEntry);

      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<DirectoryEntry> _buildDirectoryTree(String dirPath, DirectoryEntry? parent) async {
    final relativePath = p.relative(dirPath, from: widget.collection.baseDirectory);
    final children = <FileEntry>[];

    final dir = Directory(dirPath);
    await for (final entity in dir.list(recursive: true, followLinks: false)) {
      final entityRelativePath = p.relative(entity.path, from: widget.collection.baseDirectory);

      if (entity is File) {
        final stat = await entity.stat();
        children.add(
          FileEntry(
            name: entity.uri.pathSegments.last,
            path: entity.path,
            relativePath: entityRelativePath,
            size: stat.size,
          ),
        );
      } else if (entity is Directory) {
        final subTree = await _buildDirectoryTree(entity.path, parent);
        children.add(subTree);
      }
    }

    children.sort((a, b) {
      final aIsDir = a is DirectoryEntry;
      final bIsDir = b is DirectoryEntry;
      if (aIsDir && !bIsDir) return -1;
      if (!aIsDir && bIsDir) return 1;
      return a.name.toLowerCase().compareTo(b.name.toLowerCase());
    });

    final entry = DirectoryEntry(
      name: p.basename(dirPath),
      path: dirPath,
      relativePath: relativePath,
      size: 0,
      children: children,
    );

    for (final child in children) {
      child.parent = entry;
    }
    entry.parent = parent;

    return entry;
  }

  void _removeEntry(FileEntry entry) {
    setState(() {
      if (entry.parent != null) {
        final parent = entry.parent!;
        parent.children.remove(entry);
        if (parent.children.isEmpty) {
          _removeEntry(parent);
        }
      } else {
        _entries.remove(entry);
      }
    });
  }

  void _removeAll() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove All'),
        content: const Text('Are you sure you want to remove all selected files?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('CANCEL'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(_entries.clear);
            },
            child: const Text('REMOVE'),
          ),
        ],
      ),
    );
  }

  Future<bool> _onWillPop() async {
    if (_entries.isEmpty) return true;
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Discard Changes'),
        content: const Text('You have selected files. Are you sure you want to close without adding them?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('CANCEL'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('DISCARD'),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  void _toggleExpand(DirectoryEntry entry) {
    setState(() {
      if (entry.expanded) {
        entry.collapseRecursively();
      } else {
        entry.expanded = true;
      }
    });
  }

  void _confirmSelection() {
    final allFiles = _collectAllFiles(_entries);
    _addItems(allFiles);
    Navigator.of(context).pop();
  }

  List<FileEntry> _collectAllFiles(List<FileEntry> entries) {
    final files = <FileEntry>[];
    for (final entry in entries) {
      if (entry is DirectoryEntry) {
        files.addAll(_collectAllFiles(entry.children));
      } else {
        files.add(entry);
      }
    }
    return files;
  }

  void _addItems(List<FileEntry> files) {
    int addedCount = 0;
    for (final file in files) {
      final item = Item(
        collection: widget.collection,
        name: file.name,
        filePath: file.relativePath,
        itemType: ItemType.inferFromExtension(p.extension(file.name)),
      );
      if (ItemProvider.addItem(ref as Ref, item)) {
        addedCount++;
      }
    }
    if (addedCount > 0) {
      SnackBarFromZero(
        context: context,
        type: SnackBarFromZero.success,
        title: Text('Added $addedCount item(s)'),
      ).show();
    }
  }

  Widget _buildEntryTile(FileEntry entry, int depth) {
    if (entry is DirectoryEntry) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () => _toggleExpand(entry),
            child: Padding(
              padding: EdgeInsets.only(left: depth * 16.0),
              child: Row(
                children: [
                  Icon(
                    entry.expanded ? Icons.expand_more : Icons.chevron_right,
                    size: 20,
                  ),
                  Icon(
                    entry.expanded ? Icons.folder_open : Icons.folder,
                    color: Colors.amber[700],
                    size: 20,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      entry.name,
                      style: const TextStyle(fontWeight: FontWeight.w500),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, size: 18),
                    onPressed: () => _removeEntry(entry),
                    tooltip: 'Remove',
                  ),
                ],
              ),
            ),
          ),
          if (entry.expanded) ...entry.children.map((child) => _buildEntryTile(child, depth + 1)),
        ],
      );
    } else {
      return Padding(
        padding: EdgeInsets.only(left: depth * 16.0 + 24.0),
        child: Row(
          children: [
            Icon(
              _getFileIcon(entry.name),
              size: 18,
              color: Colors.grey[600],
            ),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                entry.name,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Text(
              entry.displaySize,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.close, size: 18),
              onPressed: () => _removeEntry(entry),
              tooltip: 'Remove',
            ),
          ],
        ),
      );
    }
  }

  IconData _getFileIcon(String fileName) {
    final ext = p.extension(fileName).toLowerCase();
    switch (ext) {
      case '.jpg':
      case '.jpeg':
      case '.png':
      case '.gif':
      case '.webp':
      case '.svg':
        return Icons.image;
      case '.mp4':
      case '.mkv':
      case '.avi':
      case '.mov':
      case '.webm':
        return Icons.video_file;
      case '.mp3':
      case '.wav':
      case '.flac':
      case '.aac':
      case '.ogg':
        return Icons.audio_file;
      case '.pdf':
        return Icons.picture_as_pdf;
      case '.zip':
      case '.tar':
      case '.gz':
      case '.rar':
      case '.7z':
        return Icons.archive;
      case '.txt':
      case '.md':
      case '.doc':
      case '.docx':
        return Icons.description;
      default:
        return Icons.insert_drive_file;
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final shouldPop = await _onWillPop();
        if (shouldPop && context.mounted) {
          Navigator.of(context).pop();
        }
      },
      child: DialogFromZero(
        title: Text('Add to ${widget.collection.name}'),
        maxWidth: 640,
        dialogActions: [
          DialogButton(
            onPressed: () async {
              if (_entries.isNotEmpty) {
                final shouldClose = await _onWillPop();
                if (!shouldClose || !context.mounted) return;
              }
              if (context.mounted) {
                Navigator.of(context).pop();
              }
            },
            child: const Text('CANCEL'),
          ),
          DialogButton(
            onPressed: _entries.isNotEmpty ? _confirmSelection : null,
            child: const Text('ADD'),
          ),
        ],
        content: SizedBox(
          width: double.maxFinite,
          height: 450,
          child: Column(
            children: [
              Row(
                children: [
                  FilledButton.icon(
                    onPressed: _isLoading ? null : _addFiles,
                    icon: const Icon(Icons.add),
                    label: const Text('Add Files'),
                  ),
                  const SizedBox(width: 8),
                  FilledButton.icon(
                    onPressed: _isLoading ? null : _addDirectory,
                    icon: const Icon(Icons.create_new_folder),
                    label: const Text('Add Directory'),
                  ),
                  const Spacer(),
                  if (_entries.isNotEmpty)
                    TextButton.icon(
                      onPressed: _removeAll,
                      icon: const Icon(Icons.delete_sweep),
                      label: const Text('Remove All'),
                    ),
                  if (_isLoading) ...[
                    const SizedBox(width: 16),
                    const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 8),
              if (_entries.isNotEmpty)
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '${_collectAllFiles(_entries).length} file(s) selected',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              const SizedBox(height: 4),
              const Divider(),
              Expanded(
                child: _entries.isEmpty
                    ? const Center(
                        child: Text(
                          'No files selected\nClick "Add Files" or "Add Directory" above',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey),
                        ),
                      )
                    : ListView.builder(
                        itemCount: _entries.length,
                        itemBuilder: (context, index) {
                          return _buildEntryTile(_entries[index], 0);
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SelectCollectionDialog extends StatelessWidget {
  final List<Collection> collections;
  final void Function(Collection) onSelect;

  const SelectCollectionDialog({
    required this.collections,
    required this.onSelect,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return DialogFromZero(
      title: const Text('Select Collection'),
      maxWidth: 512,
      dialogActions: const [
        DialogButton.cancel(child: Text('CANCEL')),
      ],
      content: ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 400),
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: collections.length,
          itemBuilder: (context, index) {
            final collection = collections[index];
            return ListTile(
              title: Text(collection.name),
              subtitle: Text(collection.baseDirectory ?? 'No directory set'),
              onTap: () {
                Navigator.of(context).pop();
                onSelect(collection);
              },
            );
          },
        ),
      ),
    );
  }
}

void showAddCollectionPicker(
  BuildContext context,
  WidgetRef ref,
  List<Collection> collections,
) {
  if (collections.isEmpty) {
    SnackBarFromZero(
      context: context,
      type: SnackBarFromZero.warning,
      title: const Text('No collections available'),
    ).show();
    return;
  }

  if (collections.length == 1) {
    showDialog(
      context: context,
      builder: (context) => AddItemDialog(collection: collections.first),
    );
    return;
  }

  showDialog(
    context: context,
    builder: (context) => SelectCollectionDialog(
      collections: collections,
      onSelect: (collection) => showDialog(
        context: context,
        builder: (context) => AddItemDialog(collection: collection),
      ),
    ),
  );
}
