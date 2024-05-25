import 'package:collection_app/models/tag.dart';
import 'package:isar/isar.dart';
part 'item.g.dart';


@Collection()
class Item {

  Id id = Isar.autoIncrement;

  late String? name;

  late String filePath;

  late double rating;

  late int width;

  late int height;

  late DateTime dateAdded;

  late DateTime dateLastSeen;

  final tags = IsarLinks<Tag>();

}



class FileItem implements Item {

  @override
  String filePath;

  FileItem(this.filePath);

  @override
  Id get id => throw UnimplementedError();
  @override
  set id(Id _) => throw UnimplementedError();
  @override
  String? get name => throw UnimplementedError();
  @override
  set name(String? _) => throw UnimplementedError();
  @override
  double get rating => throw UnimplementedError();
  @override
  set rating(double _) => throw UnimplementedError();
  @override
  int get width => throw UnimplementedError();
  @override
  set width(int _) => throw UnimplementedError();
  @override
  int get height => throw UnimplementedError();
  @override
  set height(int _) => throw UnimplementedError();
  @override
  DateTime get dateAdded => throw UnimplementedError();
  @override
  set dateAdded(DateTime _) => throw UnimplementedError();
  @override
  DateTime get dateLastSeen => throw UnimplementedError();
  @override
  set dateLastSeen(DateTime _) => throw UnimplementedError();
  @override
  IsarLinks<Tag> get tags => throw UnimplementedError();

}