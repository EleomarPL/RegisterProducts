import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'package:path/path.dart' as path;

class Task {
  int id;
  String name;
  double price;
  String detail;
  int amount;

  Task(this.id, this.name, this.price, this.detail, this.amount);
  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "price": price,
      "detail": detail,
      "amount": amount,
    };
  }

  Task.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'];
    price = map['price'];
    detail = map['detail'];
    amount = map['amount'];
  }
}

class DatabaseData {
  Database _db;

  initDB() async {
    _db = await openDatabase(
      path.join(await getDatabasesPath(), 'created_products_database.db'),
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE products(id INTEGER PRIMARY KEY, name VARCHAR(30) NOT NULL,price DECIMAL NOT NULL,detail TEXT NOT NULL,amount INTEGER NOT NULL);",
        );
      },
      version: 1,
    );
    print('Database inicializada');
  }

  insert(Task task) async {
    _db.insert("products", task.toMap());
  }

  Future<void> insertProduct(Task task) async {
    await _db.insert(
      'products',
      task.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
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

  Future<List<Task>> getAllTask() async {
    //List<Map<String, dynamic>> results = await _db.query("products");
    List<Map<String, dynamic>> results =
        await _db.rawQuery('SELECT * FROM products ORDER BY id ASC');
    //print(results.length);
    return results.map((map) => Task.fromMap(map)).toList();
  }

  Future<List<Task>> getSpecifiedList(String val) async {
    List<Map<String, dynamic>> results = await _db.rawQuery(
        'SELECT * FROM products WHERE name LIKE "%$val%" OR id LIKE "%$val%"');
    return results.map((map) => Task.fromMap(map)).toList();
  }
}
