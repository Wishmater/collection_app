import 'package:collection_app/models/item.dart';
import 'package:isar/isar.dart';
part 'collection.g.dart';


@Collection()
class CollectionData {

  Id id = Isar.autoIncrement;

  late String name;

  late String baseDirectory;

  late DateTime dateCreated;

  late DateTime dateLastOpened;

  late int itemCount;

  late int tagCount;

}