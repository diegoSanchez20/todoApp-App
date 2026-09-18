import 'package:sqflite/sqflite.dart';
import 'package:todo_app/database/database.dart';
import 'package:todo_app/database/tables/task_table.dart';
import 'package:todo_app/models/response/tarea_list_response.dart';

class TaskOperations {

  // Inserción masiva
  static Future<void> insertAll(List<DataTareaList> tasks) async {
    final db = await DatabaseService.database;

    await db.transaction((txn) async {

      // Obtener los IDs que ya existen en SQLite
      final existingRows = await txn.query(
        TaskTable.tableName,
        columns: ['id', 'position'],
      );

      final existingIds = <int, int>{
        for (final row in existingRows)
          row['id'] as int: row['position'] as int,
      };

      // Solamente registros que todavía NO existen
      final newTasks = tasks
          .where((task) => !existingIds.containsKey(task.id))
          .toList();

    
      if (newTasks.isNotEmpty) {

        // Mover hacia abajo todos los registros existentes
        await txn.rawUpdate(
          '''
          UPDATE ${TaskTable.tableName}
          SET position = position + ?
          ''',
          [newTasks.length],
        );

        // Insertar los nuevos al inicio
        final batch = txn.batch();

        for (int i = 0; i < newTasks.length; i++) {

          final task = newTasks[i];

          batch.insert(
            TaskTable.tableName,
            {
              'id': task.id,
              'title': task.title,
              'description': task.description,
              'completed': task.completed ? 1 : 0,
              'created_at': task.createdAt,
              'updated_at': task.updatedAt,
              'pendiente_migrar': 0,
              'position': i,
            },
          );
        }

        await batch.commit(noResult: true);
      }

     // ACTUALIZAR REGISTROS QUE YA EXISTEN
      final batchUpdate = txn.batch();

      for (final task in tasks) {

        if (existingIds.containsKey(task.id)) {

          batchUpdate.update(
            TaskTable.tableName,
            {
              'title': task.title,
              'description': task.description,
              'completed': task.completed ? 1 : 0,
              'created_at': task.createdAt,
              'updated_at': task.updatedAt,
              'pendiente_migrar': 0,
            },
            where: 'id = ?',
            whereArgs: [task.id],
          );
        }
      }

      await batchUpdate.commit(noResult: true);
    });
  }

  // Listar tarea
  static Future<TareaListResponse> getAll({required int page,required int pageSize}) async {

    final db = await DatabaseService.database;

    final offset = (page - 1) * pageSize;

    // Total de registros
    final countResult = await db.rawQuery(
      '''
      SELECT COUNT(*) as total
      FROM ${TaskTable.tableName}
      '''
    );

    final total = Sqflite.firstIntValue(countResult) ?? 0;

    // Obtener registros de la página
    final result = await db.query(
      TaskTable.tableName,
      orderBy: 'position ASC',
      limit: pageSize,
      offset: offset,
    );

    final data = result.map((item) {

      return DataTareaList(
        id: item['id'] as int,
        title: item['title'] as String,
        description: item['description'] as String,
        completed: (item['completed'] as int) == 1,
        createdAt: item['created_at'] as String,
        updatedAt: item['updated_at'] as String,
      );

    }).toList();

    // Calcular última página
    final lastPage = total == 0
        ? 1
        : (total / pageSize).ceil();

    return TareaListResponse(
      data: data,
      meta: MetaTask(
        total: total,
        perPage: pageSize,
        currentPage: page,
        lastPage: lastPage,
      ),
    );
  }

  // Falta migrar
  static Future<TareaListResponse> getAllPendientesMigrar({
    required int page,
    required int pageSize,
  }) async {

    final db = await DatabaseService.database;

    final offset = (page - 1) * pageSize;

    // Total de registros pendientes de migrar
    final countResult = await db.rawQuery(
      '''
      SELECT COUNT(*) as total
      FROM ${TaskTable.tableName}
      WHERE pendiente_migrar = 1
      '''
    );

    final total = Sqflite.firstIntValue(countResult) ?? 0;

    // Obtener registros pendientes de la página
    final result = await db.query(
      TaskTable.tableName,
      where: 'pendiente_migrar = ?',
      whereArgs: [1],
      orderBy: 'position ASC',
      limit: pageSize,
      offset: offset,
    );

    final data = result.map((item) {
      return DataTareaList(
        id: item['id'] as int,
        title: item['title'] as String,
        description: item['description'] as String,
        completed: (item['completed'] as int) == 1,
        createdAt: item['created_at'] as String,
        updatedAt: item['updated_at'] as String,
      );
    }).toList();

    // Calcular última página
    final lastPage = total == 0
        ? 1
        : (total / pageSize).ceil();

    return TareaListResponse(
      data: data,
      meta: MetaTask(
        total: total,
        perPage: pageSize,
        currentPage: page,
        lastPage: lastPage,
      ),
    );
  }

  // Registrar
  static Future<int?> createOffline({
    required String title,
    required String description,
  }) async {

    try {

      final db = await DatabaseService.database;

      final now = DateTime.now().toIso8601String();

      // Obtener el ID negativo más pequeño
      final result = await db.rawQuery(
        '''
        SELECT MIN(id) as min_id
        FROM ${TaskTable.tableName}
        WHERE id < 0
        '''
      );

      final minId = result.first['min_id'] as int?;

      final newId = minId == null
          ? -1
          : minId - 1;

      await db.transaction((txn) async {

        // MOVER TODOS LOS REGISTROS HACIA ABAJO
        await txn.rawUpdate(
          '''
          UPDATE ${TaskTable.tableName}
          SET position = position + 1
          '''
        );

        // INSERTAR NUEVO REGISTRO AL INICIO
        await txn.insert(
          TaskTable.tableName,
          {
            'id': newId,
            'title': title,
            'description': description,
            'completed': 0,
            'created_at': now,
            'updated_at': now,
            'pendiente_migrar': 1,

            // Siempre será el primero
            'position': 0,
          },
        );
      });

      return newId;

    } catch (e) {

      return null;
    }
  }

  // update
  static Future<bool> updateOffline({
    required int id,
    required String title,
    required String description,
    required bool completed,
  }) async {

    try {

      final db = await DatabaseService.database;

      final now = DateTime.now().toIso8601String();

      final affectedRows = await db.update(
        TaskTable.tableName,
        {
          'title': title,
          'description': description,
          'completed': completed ? 1 : 0,
          'updated_at': now,
          'pendiente_migrar': 1,
        },
        where: 'id = ?',
        whereArgs: [id],
      );

      return affectedRows > 0;

    } catch (e) {

      return false;
    }
  }

}