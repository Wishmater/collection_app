import 'package:collection_app/models/item.dart';
import 'package:isar/isar.dart';
part 'tag.g.dart';


@Collection()
class Tag {

  Id id = Isar.autoIncrement;

  late String name;

  late DateTime dateCreated;

  late int itemCount;

  final parentTag = IsarLink<Tag>(); // TODO 1 TEST is this nullable

  @Backlink(to: 'parentTag')
  final childrenTags = IsarLinks<Tag>();

  @Backlink(to: 'tags')
  final items = IsarLinks<Item>();

}



class DirectoryTag implements Tag {

  @override
  String name;

  DirectoryTag(this.name);

  @override
  Id get id => name.hashCode;
  @override
  set id(Id _) => throw UnimplementedError();
  @override
  DateTime get dateCreated => throw UnimplementedError();
  @override
  set dateCreated(DateTime _) => throw UnimplementedError();
  @override
  int get itemCount => throw UnimplementedError();
  @override
  set itemCount(int _) => throw UnimplementedError();
  @override
  IsarLink<Tag> get parentTag => throw UnimplementedError();
  @override
  IsarLinks<Tag> get childrenTags => throw UnimplementedError();
  @override
  IsarLinks<Item> get items => throw UnimplementedError();

}