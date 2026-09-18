import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app/services/internet_service.dart';

class TaskCreateEditController extends GetxController{
  BuildContext? context;
  final internetService = Get.find<InternetService>();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController decriptionController = TextEditingController();
  final isLoading = false.obs;

  bool isValidForm() => formKey.currentState?.validate() ?? false;

  Future<void> guardarTask() async {
    if (!isValidForm() || isLoading.value) return;
    
    isLoading.value = true;

    await Future.delayed(const Duration(seconds: 3));
    if(internetService.isConnected.value){
      Get.snackbar('Correcto', 'Con conexión a internet');
    }else{
      Get.snackbar('Error', 'Sin conexión a internet');
    }

    isLoading.value = false;
  }
}