

class Tag {

  String name;
  DateTime added;
  DateTime? lastSeen;
  DateTime? lastModified;
  Tag? parentTag; // TODO 1 validate that there are no cycles in this graph of tags
  List<Tag> childTags;
  List<Tag> secondaryParentTags;
  List<Tag> secondaryChildTags;
  List<String> aliases;

  Tag({
    this.name = '',
    DateTime? added,
    DateTime? lastModified,
    this.parentTag,
    List<Tag>? childTags,
    List<Tag>? secondaryParentTags,
    List<Tag>? secondaryChildTags,
    List<String>? aliases,
  })  : added = added ?? DateTime.now(),
        lastModified = lastModified ?? DateTime.now(),
        childTags = childTags==null ? [] : List.from(childTags),
        secondaryParentTags = secondaryParentTags==null ? [] : List.from(secondaryParentTags),
        secondaryChildTags = secondaryChildTags==null ? [] : List.from(secondaryChildTags),
        aliases = aliases==null ? [] : List.from(aliases);

  @override
  String toString() => '(Tag: $name)';

}
