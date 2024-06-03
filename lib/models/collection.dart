import 'package:collection_app/models/item.dart';
import 'package:path/path.dart' as p;


class Collection {

  String name;
  DateTime added;
  DateTime? lastSeen;
  DateTime? lastModified;
  String? baseDirectory;
  List<Item> items;

  Collection({
    this.name = 'New Collection',
    DateTime? added,
    this.lastSeen,
    this.lastModified,
    this.baseDirectory,
    List<Item>? items,
  })  : added = added ?? DateTime.now(),
        items = items ?? [];

  @override
  String toString() => '(Collection: $name)';


  String? getAbsoluteFilePathForThumbnailsFolder() {
    if (baseDirectory==null) return null;
    return p.join(baseDirectory!, '.collection_thumbnails');
  }

}
