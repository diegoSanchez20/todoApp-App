import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app/models/request/tarea_create_update_request.dart';
import 'package:todo_app/models/response/tarea_create_update_response.dart';
import 'package:todo_app/services/internet_service.dart';
import 'package:todo_app/services/task_service.dart';

class TaskCreateEditController extends GetxController{
  BuildContext? context;
  TaskService taskService = TaskService();
  final internetService = Get.find<InternetService>();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController decriptionController = TextEditingController();
  final isLoading = false.obs;
  bool yaCargo = false;

  bool isValidForm() => formKey.currentState?.validate() ?? false;

  void initData(){
    if (yaCargo)return;
    // cargar data



    yaCargo = true;
  }

  Future<void> guardarTask() async {
    if (!isValidForm() || isLoading.value) return;
    
    isLoading.value = true;

    if(internetService.isConnected.value){

      TareaCreateUpdateRequest params = TareaCreateUpdateRequest(
        title: titleController.text.trim(), 
        description: decriptionController.text.trim()
      );

      TareaCreateUpdateResponse? response = await taskService.create(params);

      if(response != null){
        Get.back(result: true);
        Get.snackbar('Correcto', 'Tarea guardada correctamente.');
      }else{
        Get.snackbar('Error', 'Ocurrió un error al guardar la tarea.');
      }

    }else{
      Get.snackbar('Error', 'Sin conexión a internet.');
    }

    isLoading.value = false;
  }
}