// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'collection.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings

extension GetCollectionDataCollection on Isar {
  IsarCollection<CollectionData> get collectionDatas => collection();
}

const CollectionDataSchema = CollectionSchema(
  name: r'CollectionData',
  schema:
      r'{"name":"CollectionData","idName":"id","properties":[{"name":"baseDirectory","type":"String"},{"name":"dateCreated","type":"Long"},{"name":"dateLastOpened","type":"Long"},{"name":"itemCount","type":"Long"},{"name":"name","type":"String"},{"name":"tagCount","type":"Long"}],"indexes":[],"links":[]}',
  idName: r'id',
  propertyIds: {
    r'baseDirectory': 0,
    r'dateCreated': 1,
    r'dateLastOpened': 2,
    r'itemCount': 3,
    r'name': 4,
    r'tagCount': 5
  },
  listProperties: {},
  indexIds: {},
  indexValueTypes: {},
  linkIds: {},
  backlinkLinkNames: {},
  getId: _collectionDataGetId,
  setId: _collectionDataSetId,
  getLinks: _collectionDataGetLinks,
  attachLinks: _collectionDataAttachLinks,
  serializeNative: _collectionDataSerializeNative,
  deserializeNative: _collectionDataDeserializeNative,
  deserializePropNative: _collectionDataDeserializePropNative,
  serializeWeb: _collectionDataSerializeWeb,
  deserializeWeb: _collectionDataDeserializeWeb,
  deserializePropWeb: _collectionDataDeserializePropWeb,
  version: 4,
);

int? _collectionDataGetId(CollectionData object) {
  if (object.id == Isar.autoIncrement) {
    return null;
  } else {
    return object.id;
  }
}

void _collectionDataSetId(CollectionData object, int id) {
  object.id = id;
}

List<IsarLinkBase<dynamic>> _collectionDataGetLinks(CollectionData object) {
  return [];
}

void _collectionDataSerializeNative(
    IsarCollection<CollectionData> collection,
    IsarCObject cObj,
    CollectionData object,
    int staticSize,
    List<int> offsets,
    AdapterAlloc alloc) {
  final baseDirectory$Bytes =
      IsarBinaryWriter.utf8Encoder.convert(object.baseDirectory);
  final name$Bytes = IsarBinaryWriter.utf8Encoder.convert(object.name);
  final size = (staticSize +
      3 +
      (baseDirectory$Bytes.length) +
      3 +
      (name$Bytes.length)) as int;
  cObj.buffer = alloc(size);
  cObj.buffer_length = size;

  final buffer = IsarNative.bufAsBytes(cObj.buffer, size);
  final writer = IsarBinaryWriter(buffer, staticSize);
  writer.writeHeader();
  writer.writeByteList(offsets[0], baseDirectory$Bytes);
  writer.writeDateTime(offsets[1], object.dateCreated);
  writer.writeDateTime(offsets[2], object.dateLastOpened);
  writer.writeLong(offsets[3], object.itemCount);
  writer.writeByteList(offsets[4], name$Bytes);
  writer.writeLong(offsets[5], object.tagCount);
}

CollectionData _collectionDataDeserializeNative(
    IsarCollection<CollectionData> collection,
    int id,
    IsarBinaryReader reader,
    List<int> offsets) {
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
    int id, IsarBinaryReader reader, int propertyIndex, int offset) {
  switch (propertyIndex) {
    case -1:
      return id as P;
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
      throw IsarError('Illegal propertyIndex');
  }
}

Object _collectionDataSerializeWeb(
    IsarCollection<CollectionData> collection, CollectionData object) {
  final jsObj = IsarNative.newJsObject();
  IsarNative.jsObjectSet(jsObj, r'baseDirectory', object.baseDirectory);
  IsarNative.jsObjectSet(
      jsObj, r'dateCreated', object.dateCreated.toUtc().millisecondsSinceEpoch);
  IsarNative.jsObjectSet(jsObj, r'dateLastOpened',
      object.dateLastOpened.toUtc().millisecondsSinceEpoch);
  IsarNative.jsObjectSet(jsObj, r'id', object.id);
  IsarNative.jsObjectSet(jsObj, r'itemCount', object.itemCount);
  IsarNative.jsObjectSet(jsObj, r'name', object.name);
  IsarNative.jsObjectSet(jsObj, r'tagCount', object.tagCount);
  return jsObj;
}

CollectionData _collectionDataDeserializeWeb(
    IsarCollection<CollectionData> collection, Object jsObj) {
  final object = CollectionData();
  object.baseDirectory = IsarNative.jsObjectGet(jsObj, r'baseDirectory') ?? '';
  object.dateCreated = IsarNative.jsObjectGet(jsObj, r'dateCreated') != null
      ? DateTime.fromMillisecondsSinceEpoch(
              IsarNative.jsObjectGet(jsObj, r'dateCreated') as int,
              isUtc: true)
          .toLocal()
      : DateTime.fromMillisecondsSinceEpoch(0);
  object.dateLastOpened =
      IsarNative.jsObjectGet(jsObj, r'dateLastOpened') != null
          ? DateTime.fromMillisecondsSinceEpoch(
                  IsarNative.jsObjectGet(jsObj, r'dateLastOpened') as int,
                  isUtc: true)
              .toLocal()
          : DateTime.fromMillisecondsSinceEpoch(0);
  object.id = IsarNative.jsObjectGet(jsObj, r'id');
  object.itemCount = IsarNative.jsObjectGet(jsObj, r'itemCount') ??
      (double.negativeInfinity as int);
  object.name = IsarNative.jsObjectGet(jsObj, r'name') ?? '';
  object.tagCount = IsarNative.jsObjectGet(jsObj, r'tagCount') ??
      (double.negativeInfinity as int);
  return object;
}

P _collectionDataDeserializePropWeb<P>(Object jsObj, String propertyName) {
  switch (propertyName) {
    case r'baseDirectory':
      return (IsarNative.jsObjectGet(jsObj, r'baseDirectory') ?? '') as P;
    case r'dateCreated':
      return (IsarNative.jsObjectGet(jsObj, r'dateCreated') != null
          ? DateTime.fromMillisecondsSinceEpoch(
                  IsarNative.jsObjectGet(jsObj, r'dateCreated') as int,
                  isUtc: true)
              .toLocal()
          : DateTime.fromMillisecondsSinceEpoch(0)) as P;
    case r'dateLastOpened':
      return (IsarNative.jsObjectGet(jsObj, r'dateLastOpened') != null
          ? DateTime.fromMillisecondsSinceEpoch(
                  IsarNative.jsObjectGet(jsObj, r'dateLastOpened') as int,
                  isUtc: true)
              .toLocal()
          : DateTime.fromMillisecondsSinceEpoch(0)) as P;
    case r'id':
      return (IsarNative.jsObjectGet(jsObj, r'id')) as P;
    case r'itemCount':
      return (IsarNative.jsObjectGet(jsObj, r'itemCount') ??
          (double.negativeInfinity as int)) as P;
    case r'name':
      return (IsarNative.jsObjectGet(jsObj, r'name') ?? '') as P;
    case r'tagCount':
      return (IsarNative.jsObjectGet(jsObj, r'tagCount') ??
          (double.negativeInfinity as int)) as P;
    default:
      throw IsarError('Illegal propertyName');
  }
}

void _collectionDataAttachLinks(
    IsarCollection<dynamic> col, int id, CollectionData object) {}

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
    bool caseSensitive = true,
    bool include = false,
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
    bool caseSensitive = true,
    bool include = false,
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
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
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
    bool caseSensitive = true,
    bool include = false,
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
    bool caseSensitive = true,
    bool include = false,
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
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
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

extension CollectionDataQueryLinks
    on QueryBuilder<CollectionData, CollectionData, QFilterCondition> {}

extension CollectionDataQueryWhereSortBy
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

extension CollectionDataQueryWhereSortThenBy
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
