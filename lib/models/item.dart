import 'package:collection_app/models/collection.dart';
import 'package:collection_app/models/tag.dart';
import 'package:collection_app/util/database_helper.dart';
import 'package:path/path.dart' as p;

class Item {
  Collection collection;

  /// reverse link
  int id;
  String name;
  DateTime added;
  DateTime? lastSeen;
  DateTime? lastModified;
  String? filePath;
  // List<String> sourceUrls; // TODO: 2 maybe implement this in the future...
  List<Tag> tags; // PERF: 2 maybe create a map from ID(name) to tag for faster search
  int? explorePriority;
  int? rating;
  List<Item>? albumChildren; // only not null if itemType==ItemType.album
  Item? albumParent; // backlink to parent, null if this item doesn't belong to an album

  // metadata
  ItemType? itemType; // technically not metadata, sometimes it is pre-defined (case of albums)
  DateTime? metadataLastUpdated;
  DateTime? fileCreated;
  DateTime? fileModified;
  int? filesize;
  int? resolutionWidth;

  /// only on types: image, video
  int? resolutionHeight;

  /// only on types: image, video
  Duration? duration;

  /// only on types: video, audio

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
    // metadata
    this.itemType,
    this.metadataLastUpdated,
    this.fileCreated,
    this.fileModified,
    this.filesize,
    this.resolutionWidth,

    /// only on types: image, video
    this.resolutionHeight,

    /// only on types: image, video
    this.duration,

    /// only on types: video, audio
    List<Item>? albumChildren,
  }) : id = id ?? DbHelper.getNextItemIdForCollection(collection),
       added = added ?? DateTime.now(),
       tags = tags ?? [],
       albumChildren = albumChildren ?? (itemType == ItemType.album ? [] : null);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Item && runtimeType == other.runtimeType && id == other.id && collection == other.collection;

  @override
  int get hashCode => collection.hashCode ^ id.hashCode;

  @override
  String toString() => '(Item: $name)';

  bool get hasMetadata => metadataLastUpdated != null;

  String? getAbsoluteFilePath() {
    if (filePath == null) return null;
    if (collection.baseDirectory == null) return filePath;
    return p.join(collection.baseDirectory!, filePath);
  }

  String? getAbsoluteFilePathForThumbnail() {
    if (filePath == null || collection.baseDirectory == null) return null;
    String result = p.join(
      collection.baseDirectory!,
      '.collection_app',
      'thumbnails',
      filePath,
    );
    result = p.setExtension(result, '.jpg');
    return result;
  }
}

enum ItemType {
  // IMPORTANT: since the index of the enum is used for serialization when saving to DB
  // we can't delete or reorder existing ItemTypes, only add new ones at the end
  image,
  video,
  audio,
  unknown,
  album;

  static const imageExtensions = ['.png', '.jpg', '.jpeg', '.webp', '.bmp'];
  // TODO: 3 test GIF files, should we treat them as videos or as images?
  static const videoExtensions = [
    '.mp4',
    '.mkv',
    '.gif',
    '.mpg',
    '.mpeg',
    '.webm',
    '.avi',
    '.rmvb',
    '.wmv',
    '.mov',
  ];
  static const audioExtensions = ['.mp3', '.wav'];
  static ItemType inferFromExtension(String extension) {
    if (!extension.startsWith('.')) extension = '.$extension';
    extension = extension.toLowerCase();
    if (imageExtensions.contains(extension)) return ItemType.image;
    if (videoExtensions.contains(extension)) return ItemType.video;
    if (audioExtensions.contains(extension)) return ItemType.audio;
    return ItemType.unknown;
  }
}
