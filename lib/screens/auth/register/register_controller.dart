import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app/services/internet_service.dart';

class RegisterController extends GetxController{
  BuildContext? context;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final isLoading = false.obs;
  final obscureText = true.obs;
  final internetService = Get.find<InternetService>();
  bool isValidForm() => formKey.currentState?.validate() ?? false;

  Future<void> registrar() async {
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