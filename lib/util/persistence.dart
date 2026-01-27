import 'dart:async';
import 'package:collection_app/models/collection.dart';
import 'package:collection_app/models/item.dart';
import 'package:collection_app/models/tag.dart';
import 'package:collection_app/services/collection_service.dart';
import 'package:collection_app/services/item_service.dart';
import 'package:collection_app/services/tag_service.dart';
import 'package:collection_app/util/database_helper.dart';
import 'package:collection_app/util/util.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

abstract class Persistence {
  static Future<void> saveCollection(Collection collection) async {
    // we need to pre-build the args arrays with the primitive values, otherwise
    // we are vulnerable to a race condition if the item object properties are
    // modified before db operation gets to execute
    const sql = /*language=SQLite*/ '''
      insert into collection 
        values (?, ?, ?, ?, ?)
      on conflict (name) do update 
        set name=?, added=?, lastSeen=?, lastModified=?, baseDirectory=?;
    ''';
    final args = [
      collection.name,
      DbHelper.datetimeFormat.format(collection.added),
      DbHelper.datetimeFormat.tryFormat(collection.lastSeen),
      DbHelper.datetimeFormat.tryFormat(collection.lastModified),
      collection.baseDirectory,
    ];
    args.addAll(
      List.from(args),
    ); // args are doubled on insert statement due to "on conflict" update statement
    return DbHelper.executeDbOperation<void>(collection, (
      db,
      operationId,
    ) async {
      db.execute(sql, args);
    });
  }

  static Future<void> saveTagToAllCollections(Tag tag) async {
    bool done = false;
    for (final collection in collectionService.getAllCollections()) {
      if (collection.tags.contains(tag)) {
        saveTagToCollection(tag, collection);
        done = true;
      }
    }
    if (!done) {
      throw Exception(
        'Trying to save tag $tag to all collection DBs, but it is not included in any collection',
      );
    }
  }

  static Future<void> saveTagToCollection(
    Tag tag,
    Collection collection,
  ) async {
    // TODO 2 PERFORMANCE make each of the queries optional
    // TODO 3 PERFORMANCE allow to add/remove specific relations instead of saving all of them
    // we need to pre-build the args arrays with the primitive values, otherwise
    // we are vulnerable to a race condition if the item object properties are
    // modified before db operation gets to execute
    List<(String, List<dynamic>)> sql = [];
    // main table upsert
    final args = [
      tag.name,
      DbHelper.datetimeFormat.format(tag.added),
      DbHelper.datetimeFormat.tryFormat(tag.lastSeen),
      DbHelper.datetimeFormat.tryFormat(tag.lastModified),
      tag.parentTag?.name,
    ];
    sql.add((
      /*language=SQLite*/ '''
      insert into tag 
        values (?, ?, ?, ?, ?)
      on conflict (name) do update 
        set name=?, added=?, lastSeen=?, lastModified=?, parentTagName=?;
    ''',
      [...args, ...args],
    ));
    // relation with tag secondary children
    sql.add((
      /*language=SQLite*/ '''
      delete from tagSecondaryChildren where childTagName=?;
    ''',
      [tag.name],
    ));
    for (final secondaryParent in tag.secondaryParentTags) {
      sql.add((
        /*language=SQLite*/ '''
        insert into tagSecondaryChildren values (?, ?);
      ''',
        [secondaryParent.name, tag.name],
      ));
    }
    // relation with tag aliases
    sql.add((
      /*language=SQLite*/ '''
      delete from tagAliases where tagName=?;
    ''',
      [tag.name],
    ));
    for (final alias in tag.aliases) {
      sql.add((
        /*language=SQLite*/ '''
        insert into tagAliases values (?, ?);
      ''',
        [tag.name, alias],
      ));
    }
    // schedule db operation to be executed when async queue is free
    return DbHelper.executeDbOperation<void>(collection, (
      db,
      operationId,
    ) async {
      final batch = db.batch();
      for (final e in sql) {
        batch.execute(e.$1, e.$2);
      }
      await batch.commit();
    });
  }

  static Future<void> saveItem(Item item) async {
    // TODO 2 PERFORMANCE make each of the queries optional
    // TODO 3 PERFORMANCE allow to add/remove specific relations instead of saving all of them
    // we need to pre-build the args arrays with the primitive values, otherwise
    // we are vulnerable to a race condition if the item object properties are
    // modified before db operation gets to execute
    List<(String, List<dynamic>)> sql = [];
    // main table upsert
    final args = [
      item.id,
      item.name,
      DbHelper.datetimeFormat.format(item.added),
      DbHelper.datetimeFormat.tryFormat(item.lastSeen),
      DbHelper.datetimeFormat.tryFormat(item.lastModified),
      item.filePath,
      item.explorePriority,
      item.rating,
      // metadata
      item.itemType?.index,
      DbHelper.datetimeFormat.tryFormat(item.metadataLastUpdated),
      DbHelper.datetimeFormat.tryFormat(item.fileCreated),
      DbHelper.datetimeFormat.tryFormat(item.fileModified),
      item.filesize,
      item.resolutionWidth,
      item.resolutionHeight,
      item.duration?.inMilliseconds,
    ];
    sql.add((
      /*language=SQLite*/ '''
      insert into item 
        values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
      on conflict (id) do update 
        set id=?, name=?, added=?, lastSeen=?, lastModified=?, filePath=?, explorePriority=?, rating=?,
            itemType=?, metadataLastUpdated=?, fileCreated=?, fileModified=?, filesize=?, 
            resolutionWidth=?, resolutionHeight=?, duration=?;
    ''',
      [...args, ...args],
    ));
    // relation with tags
    sql.add((
      /*language=SQLite*/ '''
      delete from itemTags where itemId=?;
    ''',
      [item.id],
    ));
    for (final tag in item.tags) {
      sql.add((
        /*language=SQLite*/ '''
        insert into itemTags values (?, ?);
      ''',
        [item.id, tag.name],
      ));
    }
    // relation with albumChildren
    if (item.itemType == ItemType.album) {
      sql.add((
        /*language=SQLite*/ '''
        delete from albumItems where albumId=?;
      ''',
        [item.id],
      ));
      for (int i = 0; i < item.albumChildren!.length; i++) {
        final child = item.albumChildren![i];
        sql.add((
          /*language=SQLite*/ '''
          insert into albumItems values (?, ?, ?)
        ''',
          [item.id, child.id, i],
        ));
      }
    }
    // schedule db operation to be executed when async queue is free
    return DbHelper.executeDbOperation<void>(item.collection, (
      db,
      operationId,
    ) async {
      final batch = db.batch();
      for (final e in sql) {
        batch.execute(e.$1, e.$2);
      }
      await batch.commit();
    });
  }

  // DATA LOADING AND SCHEMA MIGRATIONS, SHOULD ONLY BE CALLED ONCE ON APP STARTUP

  static Future<void> loadDataFromDb(Collection collection, Database db) async {
    // LOAD COLLECTION
    final collectionQuery = await db.rawQuery(/*language=SQLite*/ '''
      select * from collection
    ''');
    collection.name = collectionQuery[0]['name']! as String;
    collection.added = DbHelper.datetimeFormat.parse(
      collectionQuery[0]['added']! as String,
    );
    collection.lastSeen = DbHelper.datetimeFormat.tryParse(
      collectionQuery[0]['lastSeen'] as String?,
    );
    collection.lastModified = DbHelper.datetimeFormat.tryParse(
      collectionQuery[0]['lastModified'] as String?,
    );
    collection.baseDirectory = collectionQuery[0]['baseDirectory'] as String?;
    // LOAD TAGS
    // TODO 2 PERFORMANCE play around more with json_group_array, to reduce query count
    final tagQuery = await db.rawQuery(/*language=SQLite*/ '''
      select tag.*
              -- json_group_array(tA.alias) as aliases, 
              -- json_group_array(tSC.parentTagName) as parents
      from tag
      -- left join tagAliases tA on tag.name = tA.tagName
      -- left join tagSecondaryChildren tSC on tag.name = tSC.childTagName
    ''');
    // first pass to add basic tag data
    final tags = <String, Tag>{};
    for (final query in tagQuery) {
      final tagName = query['name']! as String;
      final aliasesQuery = await db.rawQuery(
        /*language=SQLite*/ '''
        select alias 
        from tagAliases
        where tagName = ?
      ''',
        [tagName],
      );
      final tag = Tag(
        name: tagName,
        added: DbHelper.datetimeFormat.parse(query['added']! as String),
        lastSeen: DbHelper.datetimeFormat.tryParse(
          query['lastSeen'] as String?,
        ),
        lastModified: DbHelper.datetimeFormat.tryParse(
          query['lastModified'] as String?,
        ),
        aliases: aliasesQuery.map((e) => e['alias']! as String).toList(),
      );
      tags[tag.name] = tag;
    }
    // second pass to add relations to other tags
    for (final query in tagQuery) {
      final tag = tags[query['name']! as String]!;
      tag.parentTag = tags[query['parentTagName'] as String?];
      final secondaryParentsQuery = await db.rawQuery(
        /*language=SQLite*/ '''
        select parentTagName 
        from tagSecondaryChildren
        where childTagName = ?
      ''',
        [tag.name],
      );
      for (final query in secondaryParentsQuery) {
        tag.secondaryParentTags.add(tags[query['parentTagName']! as String]!);
      }
    }
    // final pass to add them to collection via service, which includes filling all reverse links info
    for (final tag in tags.values) {
      tagService.addTag(
        tag,
        collection,
        checkIfAlreadyExists: false,
        saveToDb: false,
      );
    }
    // LOAD ITEMS
    // TODO 2 PERFORMANCE play around more with json_group_array, to reduce query count
    final itemQuery = await db.rawQuery(/*language=SQLite*/ '''
      select item.*
              -- json_group_array(iT.tagName) as tags
      from item
      -- left join itemTags iT on item.id = iT.itemId
    ''');
    DbHelper.nextItemId[collection] = 1;
    for (final query in itemQuery) {
      final itemId = query['id']! as int;
      final secondaryParentsQuery = await db.rawQuery(
        /*language=SQLite*/ '''
        select tagName 
        from itemTags
        where itemId = ?
      ''',
        [itemId],
      );
      final item = Item(
        collection: collection,
        id: itemId,
        name: query['name']! as String,
        added: DbHelper.datetimeFormat.parse(query['added']! as String),
        lastSeen: DbHelper.datetimeFormat.tryParse(
          query['lastSeen'] as String?,
        ),
        lastModified: DbHelper.datetimeFormat.tryParse(
          query['lastModified'] as String?,
        ),
        filePath: query['filePath'] as String?,
        explorePriority: query['explorePriority'] as int?,
        rating: query['rating'] as int?,
        tags: secondaryParentsQuery.map((e) => tags[e['tagName']! as String]!).toList(),
        itemType: query['itemType'] == null ? null : ItemType.values[query['itemType']! as int],
        metadataLastUpdated: DbHelper.datetimeFormat.tryParse(
          query['metadataLastUpdated'] as String?,
        ),
        fileCreated: DbHelper.datetimeFormat.tryParse(
          query['fileCreated'] as String?,
        ),
        fileModified: DbHelper.datetimeFormat.tryParse(
          query['fileModified'] as String?,
        ),
        filesize: query['filesize'] as int?,
        resolutionWidth: query['resolutionWidth'] as int?,
        resolutionHeight: query['resolutionHeight'] as int?,
        duration: query['duration'] == null ? null : Duration(milliseconds: query['duration']! as int),
      );
      if (DbHelper.nextItemId[collection]! <= item.id) {
        DbHelper.nextItemId[collection] = item.id + 1;
      }
      itemService.addItem(item, checkIfAlreadyExists: false, saveToDb: false);
    }
    final items = itemService.getAllItems();
    for (final album in items.where((e) => e.itemType == ItemType.album)) {
      final albumChildrenQuery = await db.rawQuery(
        /*language=SQLite*/ '''
        select childId 
        from albumItems
        where albumId = ?
        order by childIndex
      ''',
        [album.id],
      );
      for (final query in albumChildrenQuery) {
        final childId = query['childId']! as int;
        final item = items.firstWhere((e) => e.id == childId);
        itemService.addItemToAlbum(
          item,
          album,
          checkIfAlreadyExists: false,
          saveToDb: false,
        );
      }
    }
  }

  static Future<void> applySchemaMigration(
    Database db,
    int oldVersion,
    int newVersion,
  ) async {
    if (oldVersion < 1 && newVersion >= 1) {
      await db.execute(/*language=SQLite*/ '''
        create table collection(
          name text primary key not null,
          added datetime not null,
          lastSeen datetime,
          lastModified datetime,
          baseDirectory text
        );
        create table tag(
          name text primary key not null,
          added datetime not null,
          lastSeen datetime,
          lastModified datetime,
          parentTagName text,
          foreign key(parentTagName) references tag(name)
        );
        create table item(
          id int primary key not null,
          name text not null,
          added datetime not null,
          lastSeen datetime,
          lastModified datetime,
          filePath text,
          explorePriority int,
          rating int
        );
        create table tagSecondaryChildren(
          parentTagName text not null,
          childTagName text not null,
          primary key (parentTagName, childTagName),
          foreign key(parentTagName) references tag(name),
          foreign key(childTagName) references tag(name)
        );
        create table tagAliases(
          tagName text not null,
          alias text not null,
          primary key (tagName, alias),
          foreign key(tagName) references tag(name)
        );
        create table itemTags(
          itemId int not null,
          tagName text not null,
          primary key (itemId, tagName),
          foreign key(itemId) references item(id),
          foreign key(tagName) references tag(name)
        );
      ''');
    }
    if (oldVersion < 2 && newVersion >= 2) {
      await db.execute(/*language=SQLite*/ '''
        alter table item add column itemType int;
        alter table item add column metadataLastUpdated datetime;
        alter table item add column fileCreated datetime;
        alter table item add column fileModified datetime;
        alter table item add column filesize int;
        alter table item add column resolutionWidth int;
        alter table item add column resolutionHeight int;
        alter table item add column duration int;
      ''');
    }
    if (oldVersion < 3 && newVersion >= 3) {
      await db.execute(/*language=SQLite*/ '''
        create table albumItems(
          albumId int not null,
          childId int not null,
          childIndex int not null,
          primary key (albumId, childId),
          foreign key(albumId) references item(id),
          foreign key(childId) references item(id)
        );
      ''');
    }
  }
}
