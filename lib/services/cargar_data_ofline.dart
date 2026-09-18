import 'package:todo_app/database/operations/task_operations.dart';
import 'package:todo_app/models/response/tarea_list_response.dart';
import 'package:todo_app/services/task_service.dart';

class CargarDataOfline {
  final TaskService _taskService;

  CargarDataOfline({TaskService? taskService}) : _taskService = taskService ?? TaskService();

  Future<bool> cargar({int pageSize = 100}) async {
    if (pageSize <= 0) return false;

    final tasks = <DataTareaList>[];
    var pageNumber = 1;

    while (true) {
      final response = await _taskService.getAll(pageSize, pageNumber);
      if (response == null) return false;

      tasks.addAll(response.data);

      if (pageNumber >= response.meta.lastPage) break;
      pageNumber++;
    }

    await TaskOperations.insertAll(tasks);
    return true;
  }
}
