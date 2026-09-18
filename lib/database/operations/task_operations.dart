import 'package:sqflite/sqflite.dart';
import 'package:todo_app/database/database.dart';
import 'package:todo_app/database/tables/task_table.dart';
import 'package:todo_app/models/response/tarea_list_response.dart';

class TaskOperations {

  // Inserción masiva
  static Future<void> insertAll( List<DataTareaList> tasks) async {

    final db = await DatabaseService.database;

    await db.transaction((txn) async {

      final batch = txn.batch();

      for (final task in tasks) {
        batch.insert(
          TaskTable.tableName,
          {
            'id': task.id,
            'title': task.title,
            'description': task.description,
            'completed': task.completed ? 1 : 0,
            'created_at': task.createdAt,
            'updated_at': task.updatedAt,
          },
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }

      await batch.commit(noResult: true);
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
      orderBy: 'id DESC',
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

}