import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:shoppinglistapp/models/sqfmodel.dart';
import 'package:sqflite/sqflite.dart';

class HistoryDbManager extends ChangeNotifier {
  Database _database;
  String _dbName = 'history.db';
  String _tablename = 'history';
  String Colid = 'id';
  String Colproduct = 'productname';
  String Colquantity = 'quantity';
  String Colunit = 'unit';
  String Coldt = 'dateandtime';
  String Colloc = 'shopname';

  Future _openDb() async {
    if (_database != null) {
      return _database;
    }
    _database = await openDatabase(join(await getDatabasesPath(), _dbName),
        version: 1, onCreate: _onCreate);
  }

  _onCreate(Database db, int version) async {
    await db.execute(
        'CREATE TABLE $_tablename($Colid INTEGER PRIMARY KEY,$Colproduct TEXT NOT NULL,'
        ' $Colquantity TEXT NOT NULL,$Colunit TEXT NOT NULL,$Coldt TEXT NOT NULL,$Colloc TEXT)');
  }

  Future<int> insert(ItemModel items) async {
    await _openDb();
    notifyListeners();
    return await _database.insert(_tablename, items.toMap());
  }

  Future<List<ItemModel>> getQuery() async {
    await _openDb();
    final List<Map<String, dynamic>> map = await _database.query(_tablename);
    return List.generate(
      map.length,
      (i) {
        return ItemModel(
          id: map[i]['id'],
          productName: map[i]['productname'],
          quantity: double.tryParse(map[i]['quantity']),
          unit: map[i]['unit'],
          dtInfo: map[i]['dateandtime'],
          shopname: map[i]['shopname'],
        );
      },
    );
  }

  Future<int> deleteData() async {
    await _openDb();
    return await _database.delete(_tablename);
  }

  Future<int> getdbLength() async {
    await _openDb();
    final datalist = await getQuery();
    return datalist.length;
  }
}
