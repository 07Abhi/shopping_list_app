import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:shoppinglistapp/models/sqfmodel.dart';
import 'package:sqflite/sqflite.dart';

class Dbmanager extends ChangeNotifier{
  Database _database;
  String _dbname = 'cart1.db';
  String _tablename = 'cartlist1';
  String idCol = 'id';
  String productCol = 'productname';
  String quantityCol = 'quantity';
  String unitCol = 'unit';
  String dtCol = 'dateandtime';
  String locCol = 'shopname';
  int flag =0;
  Future _openDb() async {
    //if db is already created then we use it otherwise we create
    if (_database != null) {
      return _database;
    }
    _database = await openDatabase(join(await getDatabasesPath(), _dbname),
        version: 1, onCreate: _onCreate);
  }

  _onCreate(Database db, int version) async {
    await db.execute(
        'CREATE TABLE $_tablename ($idCol INTEGER PRIMARY KEY,$productCol TEXT NOT NULL,$quantityCol REAL NOT NULL, $unitCol TEXT NOT NULL,$dtCol TEXT NOT NULL,$locCol TEXT)');
  }

  Future<int> insert(ItemModel items) async {
    await _openDb();
    flag+=1;
    notifyListeners();
    return await _database.insert(_tablename, items.toMap());
  }

  Future<List<ItemModel>> getQuery() async {
    await _openDb();
    final List<Map<String, dynamic>> map = await _database.query(_tablename);
    return List.generate(map.length, (i) {
      return ItemModel(
        id: map[i]['id'],
        productName: map[i]['productname'],
        quantity: map[i]['quantity'],
        unit: map[i]['unit'],
        dtInfo: map[i]['dateandtime'],
        shopname: map[i]['shopname'],
      );
    });
  }

  Future<int> delete(int id) async {
    await _openDb();
    flag-=1;
    notifyListeners();
    return await _database.delete(_tablename, where: 'id=?', whereArgs: [id]);
  }

  Future closeConnection() async {
    await _database.close();
  }
}
