import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:todo_app/database/operations/task_operations.dart';
import 'package:todo_app/models/response/cerrar_sesion_response.dart';
import 'package:todo_app/models/response/tarea_complete_response.dart';
import 'package:todo_app/models/response/tarea_list_response.dart';
import 'package:todo_app/services/auth_service.dart';
import 'package:todo_app/services/internet_service.dart';
import 'package:todo_app/services/task_service.dart';

class TaskListarController extends GetxController{
  AuthService authService = AuthService();
  TaskService taskService = TaskService();
  final internetService = Get.find<InternetService>();
  RxList<DataTareaList> listTarea = <DataTareaList>[].obs;
  final isLoadingLogout = false.obs;
  final isLoading = false.obs;
  var pageNumber = 1.obs;
  var pageSize = 10.obs;
  var total = 0.obs;

  void initData(){
    getAll();
  }

  Future<void> cerrarSesion()async{
    if ( isLoadingLogout.value) return;
    isLoadingLogout.value = true;
    if(internetService.isConnected.value){
      CerrarSesionResponse? response = await authService.cerrarSesion();

      if(response != null){
        final storage = GetStorage();
        storage.remove('user');
        Get.offNamedUntil('/',(route) => false);
      }else{
        Get.snackbar('Error', 'Ocurrió un error al cerrar sesión.');
      }
    }else{
      Get.snackbar('Error', 'Sin conexión a internet');
    }
    isLoadingLogout.value = false;
  }

  void clean(){
    pageNumber.value = 1;
    listTarea.value = [];
  }

  void cambiarPagina(int? number)async {
    if (number == null) return;

    if (isLoading.value) return;

    if (await tienePendientesMigrar()) {
      Get.snackbar(
        'Migración pendiente',
        'Debe migrar las tareas pendientes.',
      );

      await Get.toNamed('/task-migrate');

      return;
    }


    pageNumber.value = number;
    getAll();
  }

  Future<bool> tienePendientesMigrar() async {
    if (!internetService.isConnected.value) {
      return false;
    }

    final response = await TaskOperations.getAllPendientesMigrar(
      page: 1,
      pageSize: 1,
    );

    return response.data.isNotEmpty;
  }

  Future<void> refreshData() async {
    if (isLoading.value) return;

    if (internetService.isConnected.value) {
      final responseMigrate =await TaskOperations.getAllPendientesMigrar(
        page: 1,
        pageSize: 1,
      );

      if (responseMigrate.data.isNotEmpty) {
        Get.snackbar(
          'Migración pendiente',
          'Debe migrar las tareas pendientes antes de actualizar.',
        );

        await Get.toNamed('/task-migrate');

        return;
      }
    }

    pageNumber.value = 1;

    await getAll();
  }

  Future<void> getAll()async{
    if ( isLoading.value) return;
    isLoading.value = true;

    try {
      if(internetService.isConnected.value){
        
        // Con conexión a internet
        TareaListResponse? response = await taskService.getAll(pageSize.value, pageNumber.value);
        if(response != null){
          await TaskOperations.insertAll(response.data);
          listTarea.value = response.data;
          total.value = response.meta.total;
        }
      }else if(!internetService.isConnected.value){
        // Sin conexión a internet
        final response = await TaskOperations.getAll(page: pageNumber.value,pageSize: pageSize.value);
        
        listTarea.value = response.data;
        total.value = response.meta.total;
      }
    }catch(e){
      isLoading.value = false;
    } finally{
      isLoading.value = false;
    }

  }

  Future<void> registrarTarea()async{
    if (internetService.isConnected.value) {
      final responseMigrate =await TaskOperations.getAllPendientesMigrar(
        page: 1,
        pageSize: 1,
      );

      if (responseMigrate.data.isNotEmpty) {
        Get.snackbar(
          'Migración pendiente',
          'Debe migrar las tareas pendientes antes de actualizar.',
        );

        await Get.toNamed('/task-migrate');

        return;
      }
    }

    final rpta = await Get.toNamed('/task-crear-editar');
  
    if(rpta != null){
      clean();
      getAll();
    }
  }

  Future<void> migrarTareas()async{
    final rpta = await Get.toNamed('/task-migrate');
  
    if(rpta != null){
      // clean();
      // getAll();
    }
  }

  Future<void> editarTarea(DataTareaList item)async{

    if (internetService.isConnected.value) {
      final responseMigrate =await TaskOperations.getAllPendientesMigrar(
        page: 1,
        pageSize: 1,
      );

      if (responseMigrate.data.isNotEmpty) {
        Get.snackbar(
          'Migración pendiente',
          'Debe migrar las tareas pendientes antes de actualizar.',
        );

        await Get.toNamed('/task-migrate');

        return;
      }
    }

    final rpta = await Get.toNamed(
      '/task-crear-editar',
      arguments: {
        'tarea': item
      }
    );
  
    if(rpta != null){
      clean();
      getAll();
    }
  }

  void cambiarEstadoTareaCompletado(int index, int id,DataTareaList item) async{
    try {
      
      if (internetService.isConnected.value) {
        // con conexion a internet
        final responseMigrate =await TaskOperations.getAllPendientesMigrar(
          page: 1,
          pageSize: 1,
        );

        if (responseMigrate.data.isNotEmpty) {
          Get.snackbar(
            'Migración pendiente',
            'Debe migrar las tareas pendientes antes de actualizar.',
          );

          await Get.toNamed('/task-migrate');

          return;
        }
      }

      if ( isLoading.value) return;
      isLoading.value = true;

      if(internetService.isConnected.value){

        TareaCompleteResponse? response = await taskService.completeId(id);

        if(response != null){
          isLoading.value = false;
          await getAll();
          Get.snackbar('Correcto', 'Tarea ${!item.completed ? 'completada' : 'Pendiente'}.');
        }
        isLoading.value = false;
      }else{
        final tarea = listTarea[index];

        // Nuevo estado
        final nuevoEstado = !tarea.completed;
        final actualziado = await TaskOperations.updateCompletedOffline(id:id,completed: nuevoEstado);

        if(actualziado){
          isLoading.value = false;
          await getAll();
          Get.snackbar('Correcto', 'Tarea ${!tarea.completed ? 'completada' : 'Pendiente'}.');
        }
        isLoading.value = false;
      }

      
    } catch (e) {
      isLoading.value = false;
      Get.snackbar( 'Error','Ocurrió un error, volver a intentar la acción.');
    }
  }

  void eliminarTarea(DataTareaList item) async{
    try {
      
      if ( isLoading.value) return;
      isLoading.value = true;

      if(internetService.isConnected.value){
        // con conexion a internet
        bool response = await taskService.delete(item.id);

        if(response){
          Get.snackbar('Correcto', 'Tarea eliminada correctamente.');
          isLoading.value = false;
          clean();
          await getAll();
        }else{
          isLoading.value = false;
          Get.snackbar( 'Error','No se pudo eliminar la tarea.');
        }

      }else{
        // sin conexion a internet
        final response = await TaskOperations.deleteOffline( id: item.id);

        if (response) {
          isLoading.value = false;
          await getAll();
          Get.snackbar( 'Correcto','Tarea eliminada localmente.');
        } else {
          isLoading.value = false;
          Get.snackbar( 'Error','No se pudo eliminar la tarea localmente.');
        }
      }

      
    } catch (e) {
      isLoading.value = false;
      Get.snackbar( 'Error','Ocurrió un error, volver a intentar la acción.');
    }
  }
}