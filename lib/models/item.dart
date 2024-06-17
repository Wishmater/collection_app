import 'package:collection_app/models/collection.dart';
import 'package:collection_app/models/tag.dart';
import 'package:collection_app/util/database.dart';
import 'package:path/path.dart' as p;


class Item {

  Collection collection; /// reverse link
  int id;
  String name;
  DateTime added;
  DateTime? lastSeen;
  DateTime? lastModified;
  String? filePath;
  // List<String> sourceUrls;
  // TODO 2 PERFORMANCE maybe create a map from ID(name) to tag for faster search
  List<Tag> tags;
  int? explorePriority;
  int? rating;

  Item({
    required this.collection,
    int? id,
    this.name = '',
    DateTime? added,
    this.lastSeen,
    this.lastModified,
    this.filePath,
    List<Tag>? tags,
    this.explorePriority,
    this.rating,
  })  : assert(id!=null || collection!=null, 'Item ID must be directly supplied, or a collection must be specified to get the next id from it'),
        id = id ?? DbHelper.getNextItemIdForCollection(collection!),
        added = added ?? DateTime.now(),
        tags = tags ?? [];

  @override
  bool operator ==(Object other) => identical(this, other)
      || other is Item
          && runtimeType == other.runtimeType
          && id == other.id
          && collection == other.collection;

  @override
  int get hashCode => collection.hashCode ^ id.hashCode;

  @override
  String toString() => '(Item: $name)';

  String? getAbsoluteFilePath() {
    if (filePath==null) return null;
    if (collection.baseDirectory==null) return filePath;
    return p.join(collection.baseDirectory!, filePath);
  }

  String? getAbsoluteFilePathForThumbnail() {
    if (filePath==null || collection.baseDirectory==null) return null;
    String result = p.join(collection.baseDirectory!, '.collection_app', 'thumbnails', filePath);
    result = p.setExtension(result, '.jpg');
    return result;
  }

}
