import 'package:sqflite/sqflite.dart';

class TaskTable {
  static const String tableName = 'users';

  static Future<void> create(Database db) async {
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        email TEXT NOT NULL,
        created_at TEXT NOT NULL,
        updated_at TEXT
      )
    ''');
  }
}