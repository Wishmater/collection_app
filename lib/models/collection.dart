import 'package:collection_app/models/item.dart';


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

}
