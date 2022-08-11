import 'package:collection_app/models/tag.dart';
import 'package:isar/isar.dart';
part 'item.g.dart';


@Collection()
class Item {

  Id id = isarAutoIncrementId;

  late String? name;

  late String filePath;

  late double rating;

  late int width;

  late int height;

  late DateTime dateAdded;

  late DateTime dateLastSeen;

  final tags = IsarLinks<Tag>();

}