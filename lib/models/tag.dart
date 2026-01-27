class Tag {
  String name;
  DateTime added;
  DateTime? lastSeen;
  DateTime? lastModified;
  Tag? parentTag;

  /// reverse link
  /// // TODO 2 PERFORMANCE maybe create a map from ID(name) to tag for faster search
  List<Tag> childTags;
  // TODO 2 PERFORMANCE maybe create a map from ID(name) to tag for faster search
  List<Tag> secondaryParentTags;

  /// reverse link
  // TODO 2 PERFORMANCE maybe create a map from ID(name) to tag for faster search
  List<Tag> secondaryChildTags;
  List<String> aliases;

  // TODO 1 validate (assert?) that there are no cycles in the graph of tags
  Tag({
    this.name = '',
    DateTime? added,
    this.lastSeen,
    this.lastModified,
    this.parentTag,
    List<Tag>? childTags,
    List<Tag>? secondaryParentTags,
    List<Tag>? secondaryChildTags,
    List<String>? aliases,
  }) : added = added ?? DateTime.now(),
       childTags = childTags == null ? [] : List.from(childTags),
       secondaryParentTags = secondaryParentTags == null ? [] : List.from(secondaryParentTags),
       secondaryChildTags = secondaryChildTags == null ? [] : List.from(secondaryChildTags),
       aliases = aliases == null ? [] : List.from(aliases);

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Tag && runtimeType == other.runtimeType && name == other.name;

  @override
  int get hashCode => name.hashCode;

  @override
  String toString() => '(Tag: $name)';
}
