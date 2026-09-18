import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app/models/response/register_response.dart';
import 'package:todo_app/services/auth_service.dart';
import 'package:todo_app/services/internet_service.dart';

class RegisterController extends GetxController{
  BuildContext? context;
  AuthService authService = AuthService(); 
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final isLoading = false.obs;
  final obscureText = true.obs;
  final internetService = Get.find<InternetService>();
  bool isValidForm() => formKey.currentState?.validate() ?? false;

  Future<void> registrar() async {
    if (!isValidForm() || isLoading.value) return;
    
    isLoading.value = true;


    if(internetService.isConnected.value){
      RegisterResponse? response = await authService.register(
        emailController.text, 
        passwordController.text, 
        nameController.text
      );

      if(response != null){
        Get.snackbar('Correcto', 'El usuario se registró correctamente.');
        Get.offNamedUntil('/',(route) => false);
      }else{
        Get.snackbar('Error', 'Ocurrió un error al registrar el usuario.');
      }
    }else{
      Get.snackbar('Error', 'Sin conexión a internet.');
    }

    isLoading.value = false;
  }
}