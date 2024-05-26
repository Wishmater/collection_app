import 'package:collection_app/models/collection.dart';
import 'package:collection_app/models/tag.dart';
import 'package:path/path.dart' as p;


class Item {

  String name;
  DateTime added;
  DateTime? lastSeen;
  DateTime? lastModified;
  String? filePath;
  // List<String> sourceUrls;
  List<Tag> tags;
  int? explorePriority;
  int? rating;

  Item({
    this.name = '',
    DateTime? added,
    this.lastSeen,
    this.lastModified,
    this.filePath,
    List<Tag>? tags,
    this.explorePriority,
    this.rating,
  })  : added = added ?? DateTime.now(),
        tags = tags ?? [];

  @override
  String toString() => '(Item: $name)';

  String? getAbsoluteFilePathForItem(Collection collection) {
    if (filePath==null) return null;
    if (collection.baseDirectory==null) return filePath;
    return p.join(collection.baseDirectory!, filePath);
  }

}
