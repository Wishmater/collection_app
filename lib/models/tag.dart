import 'package:collection_app/models/item.dart';
import 'package:isar/isar.dart';
part 'tag.g.dart';


@Collection()
class Tag {

  Id id = isarAutoIncrementId;

  late String name;

  late DateTime dateCreated;

  late int itemCount;

  final parentTag = IsarLink<Tag>(); // TODO 1 TEST is this nullable

  @Backlink(to: 'parentTag')
  final childrenTags = IsarLinks<Tag>();

  @Backlink(to: 'tags')
  final items = IsarLinks<Item>();

}