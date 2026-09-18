import 'package:sqflite/sqflite.dart';

class TaskTable {
  static const String tableName = 'tasks';

  static Future<void> drop(DatabaseExecutor db) async {
    await db.execute('DROP TABLE IF EXISTS $tableName');
  }

  static Future<void> create(DatabaseExecutor db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $tableName (
        id INTEGER PRIMARY KEY,
        title TEXT NOT NULL,
        description TEXT NOT NULL,
        completed INTEGER NOT NULL DEFAULT 0,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        pendiente_migrar INTEGER NOT NULL DEFAULT 0,
        position INTEGER NOT NULL,
        deleted INTEGER NOT NULL DEFAULT 0
      )
    ''');
  }
}