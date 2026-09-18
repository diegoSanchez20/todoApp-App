import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'package:todo_app/database/tables/task_table.dart';

class DatabaseService {
  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDatabase();

    return _database!;
  }

  static Future<void> recreateTasks() async {
    final db = await database;

    await db.transaction((txn) async {
      await TaskTable.drop(txn);
      await TaskTable.create(txn);
    });
  }

  static Future<Database> _initDatabase() async {
    final path = join(
      await getDatabasesPath(),
      'todo_app.db',
    );

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await TaskTable.create(db);
      },
    );
  }
}