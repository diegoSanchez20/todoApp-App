import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/database/tables/task_table.dart';
import 'package:todo_app/database/tables/user_table.dart';

class DatabaseService {
  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDatabase();

    return _database!;
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
        await UserTable.create(db);
        await TaskTable.create(db);
      },
    );
  }
}