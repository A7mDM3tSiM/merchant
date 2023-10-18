// ignore: depend_on_referenced_packages
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  static late Database _db;

  static Future init() async {
    openDatabase(
      join(await getDatabasesPath(), "merchant.db"),
      onCreate: (db, version) {
        _db = db;
        _db.execute(
          "CREATE TABLE users"
          "(id INTEGER PRIMARY KEY,"
          "name TEXT,"
          "password TEXT,"
          "created_at TEXT,"
          "updated_at TEXT,)",
        );
        _db.execute(
          "CREATE TABLE products"
          "(id INTEGER PRIMARY KEY,"
          "name TEXT,"
          "created_at TEXT,"
          "updated_at TEXT,)",
        );
        _db.execute(
          "CREATE TABLE sub_products"
          "(id INTEGER PRIMARY KEY,"
          "parent_id INTEGER"
          "name TEXT,"
          "price TEXT,"
          "total_bought INETGER,"
          "total_sold INETGER,"
          "total_sold_price INETGER,"
          "total_profit INETGER,"
          "created_at TEXT,"
          "updated_at TEXT,)",
        );
      },
      onOpen: (db) {
        _db = db;
      },
      version: 1,
    );
  }

  Future<void> insert(String table, Map<String, Object?> data) async {
    await _db.insert(table, data, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Map<String, dynamic>>> getData(String table) async {
    final query = await _db.query(table);
    return query.toList();
  }

  Future<void> updateData(
      String table, int id, Map<String, Object?> data) async {
    await _db.update(table, data, where: "id = ?", whereArgs: [id]);
  }

  Future<void> delete(String table, int id) async {
    await _db.delete(table, where: "id = ?", whereArgs: [id]);
  }
}
