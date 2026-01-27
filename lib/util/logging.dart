enum LgType {
  script('script', '[SCRIPT]'),
  db('database', '[DB]');

  final String name;
  final String print;
  const LgType(this.name, this.print);

  @override
  String toString() => print;

  /// Dado un string [s] devuelve un [LgType] opcional
  static LgType fromString(String s) {
    for (final type in LgType.values) {
      if (type.name == s) {
        return type;
      }
    }
    throw ArgumentError("String not matching", "s");
  }
}
