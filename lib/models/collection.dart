import 'package:collection_app/models/item.dart';
import 'package:collection_app/models/tag.dart';
import 'package:path/path.dart' as p;

class Collection {
  String name;
  DateTime added;
  DateTime? lastSeen;
  DateTime? lastModified;
  String? baseDirectory;
  // PERF: 2 maybe create a map from ID to item for faster search
  List<Item> items;
  // PERF: 2 maybe create a map from ID(name) to tag for faster search
  List<Tag> tags;

  /// backlink, contains all present in at least 1 item of this collection

  Collection({
    this.name = 'New Collection', // TODO: 1 validate no repeated collection/tag names (probably in DAO)
    DateTime? added,
    this.lastSeen,
    this.lastModified,
    this.baseDirectory,
    List<Item>? items,
    List<Tag>? tags,
  }) : added = added ?? DateTime.now(),
       items = items ?? [],
       tags = tags ?? [];

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Collection && runtimeType == other.runtimeType && name == other.name;

  @override
  int get hashCode => name.hashCode;

  @override
  String toString() => '(Collection: $name)';

  String? getAbsoluteFilePathForThumbnailsFolder() {
    if (baseDirectory == null) return null;
    return p.join(baseDirectory!, '.collection_app', 'thumbnails');
  }

  String? getAbsoluteFilePathForDatabase() {
    if (baseDirectory == null) return null;
    return p.join(baseDirectory!, '.collection_app', 'database.db');
  }
}
