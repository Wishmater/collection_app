// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'collection.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, avoid_js_rounded_ints, prefer_final_locals

extension GetCollectionDataCollection on Isar {
  IsarCollection<CollectionData> get collectionDatas => this.collection();
}

const CollectionDataSchema = CollectionSchema(
  name: r'CollectionData',
  id: 2450081689493535768,
  properties: {
    r'baseDirectory': PropertySchema(
      id: 0,
      name: r'baseDirectory',
      type: IsarType.string,
    ),
    r'dateCreated': PropertySchema(
      id: 1,
      name: r'dateCreated',
      type: IsarType.dateTime,
    ),
    r'dateLastOpened': PropertySchema(
      id: 2,
      name: r'dateLastOpened',
      type: IsarType.dateTime,
    ),
    r'itemCount': PropertySchema(
      id: 3,
      name: r'itemCount',
      type: IsarType.long,
    ),
    r'name': PropertySchema(
      id: 4,
      name: r'name',
      type: IsarType.string,
    ),
    r'tagCount': PropertySchema(
      id: 5,
      name: r'tagCount',
      type: IsarType.long,
    )
  },
  estimateSize: _collectionDataEstimateSize,
  serializeNative: _collectionDataSerializeNative,
  deserializeNative: _collectionDataDeserializeNative,
  deserializePropNative: _collectionDataDeserializePropNative,
  serializeWeb: _collectionDataSerializeWeb,
  deserializeWeb: _collectionDataDeserializeWeb,
  deserializePropWeb: _collectionDataDeserializePropWeb,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _collectionDataGetId,
  getLinks: _collectionDataGetLinks,
  attach: _collectionDataAttach,
  version: '3.0.0-dev.13',
);

int _collectionDataEstimateSize(
  CollectionData object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.baseDirectory.length * 3;
  bytesCount += 3 + object.name.length * 3;
  return bytesCount;
}

int _collectionDataSerializeNative(
  CollectionData object,
  IsarBinaryWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.baseDirectory);
  writer.writeDateTime(offsets[1], object.dateCreated);
  writer.writeDateTime(offsets[2], object.dateLastOpened);
  writer.writeLong(offsets[3], object.itemCount);
  writer.writeString(offsets[4], object.name);
  writer.writeLong(offsets[5], object.tagCount);
  return writer.usedBytes;
}

CollectionData _collectionDataDeserializeNative(
  Id id,
  IsarBinaryReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = CollectionData();
  object.baseDirectory = reader.readString(offsets[0]);
  object.dateCreated = reader.readDateTime(offsets[1]);
  object.dateLastOpened = reader.readDateTime(offsets[2]);
  object.id = id;
  object.itemCount = reader.readLong(offsets[3]);
  object.name = reader.readString(offsets[4]);
  object.tagCount = reader.readLong(offsets[5]);
  return object;
}

P _collectionDataDeserializePropNative<P>(
  IsarBinaryReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readDateTime(offset)) as P;
    case 2:
      return (reader.readDateTime(offset)) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Object _collectionDataSerializeWeb(
    IsarCollection<CollectionData> collection, CollectionData object) {
  /*final jsObj = IsarNative.newJsObject();*/ throw UnimplementedError();
}

CollectionData _collectionDataDeserializeWeb(
    IsarCollection<CollectionData> collection, Object jsObj) {
  /*final object = CollectionData();object.baseDirectory = IsarNative.jsObjectGet(jsObj, r'baseDirectory') ?? '';object.dateCreated = IsarNative.jsObjectGet(jsObj, r'dateCreated') != null ? DateTime.fromMillisecondsSinceEpoch(IsarNative.jsObjectGet(jsObj, r'dateCreated') as int, isUtc: true).toLocal() : DateTime.fromMillisecondsSinceEpoch(0);object.dateLastOpened = IsarNative.jsObjectGet(jsObj, r'dateLastOpened') != null ? DateTime.fromMillisecondsSinceEpoch(IsarNative.jsObjectGet(jsObj, r'dateLastOpened') as int, isUtc: true).toLocal() : DateTime.fromMillisecondsSinceEpoch(0);object.id = IsarNative.jsObjectGet(jsObj, r'id') ?? (double.negativeInfinity as int);object.itemCount = IsarNative.jsObjectGet(jsObj, r'itemCount') ?? (double.negativeInfinity as int);object.name = IsarNative.jsObjectGet(jsObj, r'name') ?? '';object.tagCount = IsarNative.jsObjectGet(jsObj, r'tagCount') ?? (double.negativeInfinity as int);*/
  //return object;
  throw UnimplementedError();
}

P _collectionDataDeserializePropWeb<P>(Object jsObj, String propertyName) {
  switch (propertyName) {
    default:
      throw IsarError('Illegal propertyName');
  }
}

Id _collectionDataGetId(CollectionData object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _collectionDataGetLinks(CollectionData object) {
  return [];
}

void _collectionDataAttach(
    IsarCollection<dynamic> col, Id id, CollectionData object) {
  object.id = id;
}

extension CollectionDataQueryWhereSort
    on QueryBuilder<CollectionData, CollectionData, QWhere> {
  QueryBuilder<CollectionData, CollectionData, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension CollectionDataQueryWhere
    on QueryBuilder<CollectionData, CollectionData, QWhereClause> {
  QueryBuilder<CollectionData, CollectionData, QAfterWhereClause> idEqualTo(
      int id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<CollectionData, CollectionData, QAfterWhereClause> idNotEqualTo(
      int id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<CollectionData, CollectionData, QAfterWhereClause> idGreaterThan(
      int id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<CollectionData, CollectionData, QAfterWhereClause> idLessThan(
      int id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<CollectionData, CollectionData, QAfterWhereClause> idBetween(
    int lowerId,
    int upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension CollectionDataQueryFilter
    on QueryBuilder<CollectionData, CollectionData, QFilterCondition> {
  QueryBuilder<CollectionData, CollectionData, QAfterFilterCondition>
      baseDirectoryEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'baseDirectory',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CollectionData, CollectionData, QAfterFilterCondition>
      baseDirectoryGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'baseDirectory',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CollectionData, CollectionData, QAfterFilterCondition>
      baseDirectoryLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'baseDirectory',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CollectionData, CollectionData, QAfterFilterCondition>
      baseDirectoryBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'baseDirectory',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CollectionData, CollectionData, QAfterFilterCondition>
      baseDirectoryStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'baseDirectory',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CollectionData, CollectionData, QAfterFilterCondition>
      baseDirectoryEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'baseDirectory',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CollectionData, CollectionData, QAfterFilterCondition>
      baseDirectoryContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'baseDirectory',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CollectionData, CollectionData, QAfterFilterCondition>
      baseDirectoryMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'baseDirectory',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CollectionData, CollectionData, QAfterFilterCondition>
      baseDirectoryIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'baseDirectory',
        value: '',
      ));
    });
  }

  QueryBuilder<CollectionData, CollectionData, QAfterFilterCondition>
      baseDirectoryIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'baseDirectory',
        value: '',
      ));
    });
  }

  QueryBuilder<CollectionData, CollectionData, QAfterFilterCondition>
      dateCreatedEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dateCreated',
        value: value,
      ));
    });
  }

  QueryBuilder<CollectionData, CollectionData, QAfterFilterCondition>
      dateCreatedGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'dateCreated',
        value: value,
      ));
    });
  }

  QueryBuilder<CollectionData, CollectionData, QAfterFilterCondition>
      dateCreatedLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'dateCreated',
        value: value,
      ));
    });
  }

  QueryBuilder<CollectionData, CollectionData, QAfterFilterCondition>
      dateCreatedBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'dateCreated',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CollectionData, CollectionData, QAfterFilterCondition>
      dateLastOpenedEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dateLastOpened',
        value: value,
      ));
    });
  }

  QueryBuilder<CollectionData, CollectionData, QAfterFilterCondition>
      dateLastOpenedGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'dateLastOpened',
        value: value,
      ));
    });
  }

  QueryBuilder<CollectionData, CollectionData, QAfterFilterCondition>
      dateLastOpenedLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'dateLastOpened',
        value: value,
      ));
    });
  }

  QueryBuilder<CollectionData, CollectionData, QAfterFilterCondition>
      dateLastOpenedBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'dateLastOpened',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CollectionData, CollectionData, QAfterFilterCondition> idEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<CollectionData, CollectionData, QAfterFilterCondition>
      idGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<CollectionData, CollectionData, QAfterFilterCondition>
      idLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<CollectionData, CollectionData, QAfterFilterCondition> idBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CollectionData, CollectionData, QAfterFilterCondition>
      itemCountEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'itemCount',
        value: value,
      ));
    });
  }

  QueryBuilder<CollectionData, CollectionData, QAfterFilterCondition>
      itemCountGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'itemCount',
        value: value,
      ));
    });
  }

  QueryBuilder<CollectionData, CollectionData, QAfterFilterCondition>
      itemCountLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'itemCount',
        value: value,
      ));
    });
  }

  QueryBuilder<CollectionData, CollectionData, QAfterFilterCondition>
      itemCountBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'itemCount',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CollectionData, CollectionData, QAfterFilterCondition>
      nameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CollectionData, CollectionData, QAfterFilterCondition>
      nameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CollectionData, CollectionData, QAfterFilterCondition>
      nameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CollectionData, CollectionData, QAfterFilterCondition>
      nameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'name',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CollectionData, CollectionData, QAfterFilterCondition>
      nameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CollectionData, CollectionData, QAfterFilterCondition>
      nameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CollectionData, CollectionData, QAfterFilterCondition>
      nameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CollectionData, CollectionData, QAfterFilterCondition>
      nameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'name',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CollectionData, CollectionData, QAfterFilterCondition>
      nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<CollectionData, CollectionData, QAfterFilterCondition>
      nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<CollectionData, CollectionData, QAfterFilterCondition>
      tagCountEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'tagCount',
        value: value,
      ));
    });
  }

  QueryBuilder<CollectionData, CollectionData, QAfterFilterCondition>
      tagCountGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'tagCount',
        value: value,
      ));
    });
  }

  QueryBuilder<CollectionData, CollectionData, QAfterFilterCondition>
      tagCountLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'tagCount',
        value: value,
      ));
    });
  }

  QueryBuilder<CollectionData, CollectionData, QAfterFilterCondition>
      tagCountBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'tagCount',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension CollectionDataQueryObject
    on QueryBuilder<CollectionData, CollectionData, QFilterCondition> {}

extension CollectionDataQueryLinks
    on QueryBuilder<CollectionData, CollectionData, QFilterCondition> {}

extension CollectionDataQuerySortBy
    on QueryBuilder<CollectionData, CollectionData, QSortBy> {
  QueryBuilder<CollectionData, CollectionData, QAfterSortBy>
      sortByBaseDirectory() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'baseDirectory', Sort.asc);
    });
  }

  QueryBuilder<CollectionData, CollectionData, QAfterSortBy>
      sortByBaseDirectoryDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'baseDirectory', Sort.desc);
    });
  }

  QueryBuilder<CollectionData, CollectionData, QAfterSortBy>
      sortByDateCreated() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateCreated', Sort.asc);
    });
  }

  QueryBuilder<CollectionData, CollectionData, QAfterSortBy>
      sortByDateCreatedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateCreated', Sort.desc);
    });
  }

  QueryBuilder<CollectionData, CollectionData, QAfterSortBy>
      sortByDateLastOpened() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateLastOpened', Sort.asc);
    });
  }

  QueryBuilder<CollectionData, CollectionData, QAfterSortBy>
      sortByDateLastOpenedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateLastOpened', Sort.desc);
    });
  }

  QueryBuilder<CollectionData, CollectionData, QAfterSortBy> sortByItemCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'itemCount', Sort.asc);
    });
  }

  QueryBuilder<CollectionData, CollectionData, QAfterSortBy>
      sortByItemCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'itemCount', Sort.desc);
    });
  }

  QueryBuilder<CollectionData, CollectionData, QAfterSortBy> sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<CollectionData, CollectionData, QAfterSortBy> sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<CollectionData, CollectionData, QAfterSortBy> sortByTagCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tagCount', Sort.asc);
    });
  }

  QueryBuilder<CollectionData, CollectionData, QAfterSortBy>
      sortByTagCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tagCount', Sort.desc);
    });
  }
}

extension CollectionDataQuerySortThenBy
    on QueryBuilder<CollectionData, CollectionData, QSortThenBy> {
  QueryBuilder<CollectionData, CollectionData, QAfterSortBy>
      thenByBaseDirectory() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'baseDirectory', Sort.asc);
    });
  }

  QueryBuilder<CollectionData, CollectionData, QAfterSortBy>
      thenByBaseDirectoryDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'baseDirectory', Sort.desc);
    });
  }

  QueryBuilder<CollectionData, CollectionData, QAfterSortBy>
      thenByDateCreated() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateCreated', Sort.asc);
    });
  }

  QueryBuilder<CollectionData, CollectionData, QAfterSortBy>
      thenByDateCreatedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateCreated', Sort.desc);
    });
  }

  QueryBuilder<CollectionData, CollectionData, QAfterSortBy>
      thenByDateLastOpened() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateLastOpened', Sort.asc);
    });
  }

  QueryBuilder<CollectionData, CollectionData, QAfterSortBy>
      thenByDateLastOpenedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateLastOpened', Sort.desc);
    });
  }

  QueryBuilder<CollectionData, CollectionData, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<CollectionData, CollectionData, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<CollectionData, CollectionData, QAfterSortBy> thenByItemCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'itemCount', Sort.asc);
    });
  }

  QueryBuilder<CollectionData, CollectionData, QAfterSortBy>
      thenByItemCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'itemCount', Sort.desc);
    });
  }

  QueryBuilder<CollectionData, CollectionData, QAfterSortBy> thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<CollectionData, CollectionData, QAfterSortBy> thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<CollectionData, CollectionData, QAfterSortBy> thenByTagCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tagCount', Sort.asc);
    });
  }

  QueryBuilder<CollectionData, CollectionData, QAfterSortBy>
      thenByTagCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tagCount', Sort.desc);
    });
  }
}

extension CollectionDataQueryWhereDistinct
    on QueryBuilder<CollectionData, CollectionData, QDistinct> {
  QueryBuilder<CollectionData, CollectionData, QDistinct>
      distinctByBaseDirectory({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'baseDirectory',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CollectionData, CollectionData, QDistinct>
      distinctByDateCreated() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dateCreated');
    });
  }

  QueryBuilder<CollectionData, CollectionData, QDistinct>
      distinctByDateLastOpened() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dateLastOpened');
    });
  }

  QueryBuilder<CollectionData, CollectionData, QDistinct>
      distinctByItemCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'itemCount');
    });
  }

  QueryBuilder<CollectionData, CollectionData, QDistinct> distinctByName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CollectionData, CollectionData, QDistinct> distinctByTagCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'tagCount');
    });
  }
}

extension CollectionDataQueryProperty
    on QueryBuilder<CollectionData, CollectionData, QQueryProperty> {
  QueryBuilder<CollectionData, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<CollectionData, String, QQueryOperations>
      baseDirectoryProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'baseDirectory');
    });
  }

  QueryBuilder<CollectionData, DateTime, QQueryOperations>
      dateCreatedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dateCreated');
    });
  }

  QueryBuilder<CollectionData, DateTime, QQueryOperations>
      dateLastOpenedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dateLastOpened');
    });
  }

  QueryBuilder<CollectionData, int, QQueryOperations> itemCountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'itemCount');
    });
  }

  QueryBuilder<CollectionData, String, QQueryOperations> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }

  QueryBuilder<CollectionData, int, QQueryOperations> tagCountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'tagCount');
    });
  }
}
