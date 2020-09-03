import 'package:restaurantpos/providers/cart_provider.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

/*
* TODO- showing staging orders from mbl store-> confirm staging order and remove from mbl store
* */

class DBHelper {
  // Static method is available without the need to instantiate the class first
  static final _dbName = 'halkhata.db';

  //create item table
  static final _createItemTable =
      'CREATE TABLE items(item_id TEXT PRIMARY KEY, item_title TEXT, price TEXT)';
  //create category table
  static final _createCategoryTable =
      'CREATE TABLE categories(category_id TEXT PRIMARY KEY, category_description TEXT, category_image TEXT)';
  //create cart table
  static final _createCartTable =
      'CREATE TABLE cart_items(itemId PRIMARY KEY, id TEXT, title text, quantity INTEGER, price TEXT)';

  //create staging order table
  static final _createStagingOrderTable =
      'CREATE TABLE staging_orders(id TEXT PRIMARY KEY, total_amount TEXT, date_time TEXT, vat TEXT)';
  static final _createStagingOrderItemsTable =
      'CREATE TABLE staging_items(id TEXT, itemId TEXT, title TEXT, quantity TEXT, price TEXT)';

  //create order table
  static final _createOrderTable =
      'CREATE TABLE orders(order_ref TEXT PRIMARY KEY, waiter_id TEXT, restaurant_id TEXT, total_amount TEXT, order_date TEXT)';
  static final _createOrderItemsTable =
      'CREATE TABLE order_items(id TEXT, item_id TEXT, title TEXT, quantity TEXT, price TEXT)';

  static Future<Database> database() async {
    final dbPath = await sql.getDatabasesPath();
    return sql.openDatabase(path.join(dbPath, _dbName),
        onCreate: //db = database which was created for you by SQFLite version = current version
            (db,
                version) //onCreate takes a function and you can use a named or an anonymous function, a function which will execute when SQFLite tries to open the database and doesn't find the file.Then it goes ahead and creates the file
            {
      db.execute(_createItemTable);
      db.execute(_createCategoryTable);
      db.execute(_createStagingOrderTable);
      db.execute(_createStagingOrderItemsTable);
      db.execute(_createOrderTable);
      db.execute(_createOrderItemsTable);
      db.execute(_createCartTable);
    }, version: 1);
  }

  //insert row to a table
  static Future<void> insert(String table, Map<String, Object> data) async {
    final db = await DBHelper.database();
    db..insert(table, data, conflictAlgorithm: sql.ConflictAlgorithm.replace);
  }

  //returns all rows of a table
  static Future<List<Map<String, dynamic>>> getData(String table) async {
    final db = await DBHelper.database();
    return db.query(table);
  }

  //get a row with id from a table
  static Future<List<Map<String, dynamic>>> getDataWithId(
      String table, String id, String column) async {
    final db = await DBHelper.database();
    var queryResult =
        await db.rawQuery('SELECT * FROM $table WHERE $column= ?', ["$id"]);
    return queryResult;
  }

  //checks if a table contains certain 'id'
  static Future<bool> checkIdContainsInTable(
      String table, String id, String column) async {
    final db = await DBHelper.database();
    var queryResult =
        await db.rawQuery('SELECT * FROM $table WHERE $column= ?', ['$id']);
    print('does contain= $queryResult');
    if (queryResult.isEmpty)
      return false; //doesn't contain id
    else
      return true;
  }

  //checks whether a table is empty or not
  static Future<bool> checkEmptyTable(String table) async {
    final db = await DBHelper.database();
    var queryResult = await db.rawQuery('SELECT * from $table');
    //  print('checkEmptyTable = $queryResult');
    if (queryResult.isEmpty)
      return true; //empty table
    else
      return false; // not empty table
  }

  //get id from cart_items table
  static Future<String> getCartItemsId(String table) async {
    final db = await DBHelper.database();
    List<Map> queryResult = await db.rawQuery('SELECT * from $table');
    String _id = queryResult[0]['id'];
    print('cart id $_id');
    return _id;
  }

  /*static Future<int> countRows(String table) async {
    //database connection
    final db = await DBHelper.database();
    var x = await db.rawQuery('SELECT COUNT (*) from $table');
    int count = Sqflite.firstIntValue(x);
    return count;
  }*/

  //get the list of cart items from a order or staging_order table
  static Future<List<CartItemProvider>> queryStagingOrderItem(
      String id, String table) async {
    final db = await DBHelper.database();
    List<CartItemProvider> finalResult = [];
    List<Map> result =
        await db.rawQuery('select * from $table where id = ?', ['$id']);
    for (int i = 0; i < result.length; i++) {
      finalResult.add(CartItemProvider(
          id: result[i]['id'],
          itemId: result[i]['itemId'],
          title: result[i]['title'],
          quantity: int.parse(result[i]['quantity']),
          price: double.parse(result[i]['price'])));
    }
    //print('staging orders- $result');
    return finalResult;
  }

  //returning quantity value from cart_items
  static Future<int> queryQuantityFromCart(
      String table, String id, String column) async {
    final db = await DBHelper.database();
    List<Map> list =
        await db.rawQuery('SELECT * FROM $table WHERE $column ="$id"');
    int qty = list[0]['quantity'];
    return qty;
  }

  //removes a row from a table with id
  static Future<void> removeRow(
      String table, String id, String columnId) async {
    final db = await DBHelper.database();
    db.delete(table, where: '$columnId = ?', whereArgs: [id]);
    // db.rawDelete('DELETE FROM $table WHERE $columnId = ?', ['$id']);
  }

  //removes all rows from a table
  static Future<void> removeAllRows(String table) async {
    final db = await DBHelper.database();
    db.delete(table, where: null, whereArgs: null);
    // db.rawDelete('DELETE FROM $table');
  }

  //updates quantity in cart_items table
  static Future<void> updateCartItemQnty(
      String table, int quantity, String id, String column) async {
    final db = await DBHelper.database();
    db.rawUpdate(
        'UPDATE $table SET quantity = $quantity WHERE $column = "$id"');
  }
}
