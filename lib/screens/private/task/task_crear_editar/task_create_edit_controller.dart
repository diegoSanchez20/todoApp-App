import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app/database/operations/task_operations.dart';
import 'package:todo_app/models/request/tarea_create_request.dart';
import 'package:todo_app/models/request/tarea_update_request.dart';
import 'package:todo_app/models/response/tarea_create_response.dart';
import 'package:todo_app/models/response/tarea_list_response.dart';
import 'package:todo_app/models/response/tarea_update_response.dart';
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
  late DataTareaList? tarea;
  bool yaCargo = false;

  bool isValidForm() => formKey.currentState?.validate() ?? false;

  void initData(){
    if (yaCargo)return;
    // cargar data

    final arguments = Get.arguments;
    if (arguments != null && arguments['tarea'] != null) {
      tarea = arguments['tarea'] as DataTareaList;
      titleController.text = tarea?.title ?? '';
      decriptionController.text = tarea?.description ?? '';
    } else {
      tarea = null;
    }

    yaCargo = true;
  }

  Future<void> guardarTask() async {
    if (!isValidForm() || isLoading.value) return;
    
    isLoading.value = true;

    if(tarea == null){
      if(internetService.isConnected.value){
        // Con conexión a internet
        TareaCreateRequest params = TareaCreateRequest(
          title: titleController.text.trim(), 
          description: decriptionController.text.trim()
        );

        TareaCreateResponse? response = await taskService.create(params);

        if(response != null){
          Get.back(result: true);
          Get.snackbar('Correcto', 'Tarea guardada correctamente.');
        }

      }else{
        // Sin conexion a internet
        final id = await TaskOperations.createOffline(
          title: titleController.text.trim(),
          description: decriptionController.text.trim(),
        );

        if (id != null) {
          Get.back(result: true);

          Get.snackbar(
            'Correcto',
            'Tarea guardada correctamente.',
          );
        } else {
          Get.snackbar(
            'Error',
            'No se pudo guardar la tarea.',
          );
        }
      }
    }else{
      if(internetService.isConnected.value){
        //Con conexion a internet
        TareaUpdateRequest params = TareaUpdateRequest(
          completed: tarea!.completed,
          title: titleController.text.trim(), 
          description: decriptionController.text.trim()
        );

        TareaUpdateResponse? response = await taskService.edit(params,tarea!.id);

        if(response != null){
          Get.back(result: true);
          Get.snackbar('Correcto', 'Tarea actualizada correctamente.');
        }else{
          Get.snackbar('Error', 'Ocurrió un error al crear la tarea.');
        }
      }else{
        // Sin conexión a internet
        final success = await TaskOperations.updateOffline(
          id: tarea!.id,
          title: titleController.text.trim(),
          description: decriptionController.text.trim(),
          completed: tarea!.completed,
        );

        if (success) {
          Get.back(result: true);

          Get.snackbar(
            'Correcto',
            'Tarea actualizada correctamente.',
          );
        } else {
          Get.snackbar(
            'Error',
            'Ocurrió un error al actualizar la tarea.',
          );
        }
      }
    }


    isLoading.value = false;
  }
}