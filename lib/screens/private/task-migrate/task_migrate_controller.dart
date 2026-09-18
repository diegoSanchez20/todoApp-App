import 'package:get/get.dart';
import 'package:todo_app/database/operations/task_operations.dart';
import 'package:todo_app/models/response/tarea_list_response.dart';
import 'package:todo_app/services/internet_service.dart';

class TaskMigrateController extends GetxController{
  final isLoading = false.obs;
  var pageNumber = 1.obs;
  var total = 0.obs;
  var pageSize = 10.obs;
  RxList<DataTareaList> listTarea = <DataTareaList>[].obs;
  final internetService = Get.find<InternetService>();

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

  }
}