import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
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

  void getAll()async{
    if ( isLoading.value) return;
    isLoading.value = true;

    if(internetService.isConnected.value){
      TareaListResponse? response = await taskService.getAll(pageSize.value, pageNumber.value);
      if(response != null){
        listTarea.value = [...listTarea,...response.data];
      }
    }else{
      Get.snackbar('Error', 'Sin conexión a internet');
    }
    isLoading.value = false;
  }

  Future<void> registrarTarea()async{
    final rpta = await Get.toNamed('/task-crear-editar');
  
    if(rpta != null){
      clean();
      getAll();
    }
  }

  Future<void> editarTarea(DataTareaList item)async{
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

  void cambiarEstadoTareaCompletado(int index, int id) async{

    if ( isLoading.value) return;
    isLoading.value = true;

    if(internetService.isConnected.value){

      TareaCompleteResponse? response = await taskService.completeId(id);

      if(response != null){
        final tarea = listTarea[index];

        tarea.completed = !tarea.completed;

        listTarea.refresh();
        Get.snackbar('Correcto', 'Tarea ${tarea.completed ? 'completada' : 'Pendiente'}.');
      }else{
        Get.snackbar('Error', 'Ocurrió un error al actualizar la tarea.');
      }

    }else{
      Get.snackbar('Error', 'Sin conexión a internet.');
    }

    isLoading.value = false;
  }

  void eliminarTarea(DataTareaList item) async{

    if ( isLoading.value) return;
    isLoading.value = true;

    if(internetService.isConnected.value){

      bool response = await taskService.delete(item.id);

      if(response){
        Get.snackbar('Correcto', 'Tarea eliminada correctamente.');
        isLoading.value = false;
        clean();
        getAll();
      }else{
        Get.snackbar('Error', 'Ocurrió un error al eliminar la tarea.');
      }

    }else{
      Get.snackbar('Error', 'Sin conexión a internet.');
    }

    isLoading.value = false;
  }
}