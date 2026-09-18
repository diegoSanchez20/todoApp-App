import 'package:get/get.dart';
import 'package:todo_app/database/operations/task_operations.dart';
import 'package:todo_app/models/request/tarea_create_request.dart';
import 'package:todo_app/models/request/tarea_update_request.dart';
import 'package:todo_app/models/response/tarea_create_response.dart';
import 'package:todo_app/models/response/tarea_list_response.dart';
import 'package:todo_app/models/response/tarea_update_response.dart';
import 'package:todo_app/services/internet_service.dart';
import 'package:todo_app/services/task_service.dart';

class TaskMigrateController extends GetxController{
  final isLoading = false.obs;
  var pageNumber = 1.obs;
  var total = 0.obs;
  var pageSize = 10.obs;
  RxList<DataTareaList> listTarea = <DataTareaList>[].obs;
  final internetService = Get.find<InternetService>();
  TaskService taskService = TaskService();

  void initData(){
    getAll();
  }

  Future<void> refreshData() async {

    pageNumber.value = 1;

    await getAll();
  }

  Future<void> getAll()async{
    if ( isLoading.value) return;
    isLoading.value = true;

    try {
      
      // Sin conexión a internet
      final response = await TaskOperations.getAllPendientesMigrar(page: pageNumber.value,pageSize: pageSize.value);
      listTarea.value = response.data;
      total.value = response.meta.total;
      
    }catch(e){
      isLoading.value = false;
    } finally{
      isLoading.value = false;
    }
  }

  void migrarTarea(DataTareaList item)async{
    if (isLoading.value) return;

    if(!internetService.isConnected.value){
      // sin conexion
      Get.snackbar(
        'Error',
        'Usted no cuenta con conexion internet.',
      );
      return;
    }
    isLoading.value = true;

    try {
      if(item.id < 0){
        //crear
        TareaCreateRequest params = TareaCreateRequest(
          title: item.title.trim(), 
          description: item.description.trim()
        );

        TareaCreateResponse? response = await taskService.create(params);

        if(response != null){
          // ID que generó el servidor
          final idServidor = response.data.id;

          // Actualizar SQLite
          final actualizado = await TaskOperations.marcarComoMigradaNueva(
            idOffline: item.id,
            idServidor: idServidor,
          );

          if(actualizado){
            listTarea.remove(item);
            total.value--;
            Get.snackbar('Correcto', 'Tarea migrada correctamente.');
          }
        }
      }else{
        // actualizar
        TareaUpdateRequest params = TareaUpdateRequest(
          completed: item.completed,
          title: item.title.trim(), 
          description: item.description.trim()
        );

        TareaUpdateResponse? response = await taskService.edit(params,item.id);

        if(response != null){
          // Marcar como migrada en SQLite
          final actualizado =await TaskOperations.marcarComoMigradaExistente(
            id: item.id,
          );
          
          if (actualizado){
            listTarea.remove(item);
            total.value--;
            Get.snackbar('Correcto', 'Tarea migrada correctamente.');
          }
        }
      }
    } finally {
      isLoading.value = false;
    }
  }

  void cambiarPagina(int? number)async {
    if (number == null) return;

    if (isLoading.value) return;

    pageNumber.value = number;
    getAll();
  }
}