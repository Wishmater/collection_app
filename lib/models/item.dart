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

  late Collection collection; /// reverse link

  Item({
    this.name = '',
    DateTime? added,
    this.lastSeen,
    this.lastModified,
    this.filePath,
    List<Tag>? tags,
    this.explorePriority,
    this.rating,
    Collection? collection,
  })  : added = added ?? DateTime.now(),
        tags = tags ?? []
  {
    if (collection!=null) {
      this.collection = collection;
    }
  }

  @override
  String toString() => '(Item: $name)';

  String? getAbsoluteFilePath() {
    if (filePath==null) return null;
    if (collection.baseDirectory==null) return filePath;
    return p.join(collection.baseDirectory!, filePath);
  }

  String? getAbsoluteFilePathForThumbnail() {
    if (filePath==null || collection.baseDirectory==null) return null;
    String result = p.join(collection.baseDirectory!, '.collection_thumbnails', filePath);
    result = p.setExtension(result, '.jpg');
    return result;
  }

}
