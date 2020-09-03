import 'dart:io';

import 'package:path/path.dart';

import 'package:path_provider/path_provider.dart';
import 'package:point_of_sale6/models/item_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider {
  static Database _database;
  static final DBProvider db = DBProvider._();

  DBProvider._();

  Future<Database> get database async {
    // If database exists, return database
    if (_database != null) return _database;

    // If database don't exists, create one
    _database = await initDB();

    return _database;
  }

  // Create the database and the Employee table
  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'halkhata.db');

    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute(
          'CREATE TABLE items(item_id TEXT PRIMARY KEY, item_title TEXT, price TEXT)');
      /* await db.execute(
          'CREATE TABLE orders(order_ref TEXT PRIMARY KEY,order_list TEXT FOREIGN KEY,waiter_id TEXT, restaurant_id TEXT, total_price TEXT, order_date TEXT, date TEXT)');
      await db.execute();*/
    });
  }

  // Insert employee on database
  createItem(ItemProvider newItem) async {
    await deleteItems(); //delete all items
    final db = await database;
    final res = await db.insert('items', newItem.toJson());

    return res;
  }

  // Delete all employees
  Future<int> deleteItems() async {
    final db = await database;
    final res = await db.rawDelete('DELETE FROM items');

    return res;
  }

  Future<List<ItemProvider>> getAllItems() async {
    final db = await database;
    final res = await db.rawQuery("SELECT * FROM items");

    List<ItemProvider> list =
        res.isNotEmpty ? res.map((c) => ItemProvider.fromJson(c)).toList() : [];

    return list;
  }
}
