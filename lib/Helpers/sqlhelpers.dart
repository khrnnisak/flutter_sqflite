import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqflite.dart';
import '../Model/item.dart';
//SQLHelper

class SQLHelper {
  static SQLHelper? _sqlHelper;
  static Database? _database;
  SQLHelper._createObject();

  Future<Database> db() async {
    //untuk menentukan nama database dan lokasi yg dibuat
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'items.db';

    //create, read databases
    var itemDatabase = openDatabase(path, version: 1, onCreate: _createDb);

    return itemDatabase;
  }

  void _createDb(Database db, int version) async {
    await db.execute('''
      CREATE TABLE item (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT,
      price INTEGER
      )
  ''');
  }

  // Read all items
  Future<List<Map<String, dynamic>>> select() async {
    Database db = await this.db();
    var mapList = await db.query('item', orderBy: 'name');
    return mapList;
  }

  // Create new item
  Future<int> createItem(Item object) async {
    Database db = await this.db();
    int count = await db.insert('item', object.toMap());
    return count;
  }

  // Update an item by id
  Future<int> updateItem(Item object) async {
    Database db = await this.db();
    int count = await db
        .update('item', object.toMap(), where: 'id=?', whereArgs: [object.id]);
    return count;
  }

  // Delete an item by id
  Future<int> deleteItem(int id) async {
    Database db = await this.db();
    int count = await db.delete('item', where: 'id=?', whereArgs: [id]);
    return count;
  }

  Future<List<Item>> getItemList() async {
    var itemMapList = await select();
    int count = itemMapList.length;

    List<Item> itemList = <Item>[];
    for (int i = 0; i < count; i++) {
      itemList.add(Item.fromMap(itemMapList[i]));
    }
    return itemList;
  }

  factory SQLHelper() {
    if (_sqlHelper == null) {
      _sqlHelper = SQLHelper._createObject();
    }
    return _sqlHelper!;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await db();
    }
    return _database!;
  }
}
