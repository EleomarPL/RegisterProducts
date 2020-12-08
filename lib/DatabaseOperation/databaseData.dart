import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'package:path/path.dart' as path;
import 'package:productos/DatabaseOperation/Task.dart';

class DatabaseData {
  Database _db;
  initDB() async {
    _db = await openDatabase(
      path.join(await getDatabasesPath(), 'created_products_database.db'),
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE products(id INTEGER PRIMARY KEY, name VARCHAR(30) NOT NULL,price REAL NOT NULL,detail TEXT NOT NULL,amount INTEGER NOT NULL);",
        );
      },
      version: 1,
    );
    print('Database inicializada');
  }

  Future<void> insertProduct(Task task) async {
    int idRegister = await _db.insert(
      'products',
      task.toMap(),
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
    return idRegister;
  }

  Future<int> queryId(int id) async {
    int resultQueryId = Sqflite.firstIntValue(
        await _db.rawQuery('SELECT * FROM products WHERE id = ?', ['$id']));
    return resultQueryId;
  }

  Future<void> updateProduct(Task task) async {
    await _db.update(
      'products',
      task.toMap(),
      where: "id = ?",
      whereArgs: [task.id],
    );
  }

  Future<void> deleteProduct(int id) async {
    await _db.rawDelete('DELETE FROM products WHERE id = ?', [id]);
  }

  Future<List<Task>> getSpecifiedList(String val) async {
    List<Map<String, dynamic>> results = await _db.rawQuery(
        'SELECT * FROM products WHERE name LIKE ? OR id LIKE ?',
        ['%$val%', '%$val%']);
    return results.map((map) => Task.fromMap(map)).toList();
  }
}
