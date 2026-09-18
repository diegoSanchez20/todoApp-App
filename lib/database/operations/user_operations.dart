import 'package:todo_app/database/database.dart';

class UserOperations {

  // CREAR
  Future<int> create({
    required String name,
    required String email,
  }) async {

    final db = await DatabaseService.database;

    return await db.insert(
      'users',
      {
        'name': name,
        'email': email,
        'created_at': DateTime.now().toIso8601String(),
      },
    );
  }

  // OBTENER TODOS
  Future<List<Map<String, dynamic>>> getAll() async {

    final db = await DatabaseService.database;

    return await db.query(
      'users',
      orderBy: 'id DESC',
    );
  }

  // OBTENER POR ID
  Future<Map<String, dynamic>?> getById(int id) async {

    final db = await DatabaseService.database;

    final result = await db.query(
      'users',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (result.isEmpty) {
      return null;
    }

    return result.first;
  }

  // BUSCAR POR EMAIL
  Future<Map<String, dynamic>?> getByEmail(
    String email,
  ) async {

    final db = await DatabaseService.database;

    final result = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
      limit: 1,
    );

    if (result.isEmpty) {
      return null;
    }

    return result.first;
  }

  // EDITAR
  Future<int> update({
    required int id,
    required String name,
    required String email,
  }) async {

    final db = await DatabaseService.database;

    return await db.update(
      'users',
      {
        'name': name,
        'email': email,
        'updated_at': DateTime.now().toIso8601String(),
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // ELIMINAR
  Future<int> delete(int id) async {

    final db = await DatabaseService.database;

    return await db.delete(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}