import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:todo_app/database/database.dart';
import 'package:todo_app/models/response/login_response.dart';
import 'package:todo_app/services/auth_service.dart';
import 'package:todo_app/services/cargar_data_ofline.dart';
import 'package:todo_app/services/internet_service.dart';

class LoginController extends GetxController{
  BuildContext? context;
  AuthService authService = AuthService(); 
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final isLoading = false.obs;
  final obscureText = true.obs;
  final internetService = Get.find<InternetService>();
  bool isValidForm() => formKey.currentState?.validate() ?? false;

  Future<void> iniciarSesion() async {
    if (!isValidForm() || isLoading.value) return;
    try {
      
      isLoading.value = true;

      if(internetService.isConnected.value){
        LoginResponse? response = await authService.login(
          emailController.text, 
          passwordController.text, 
        );

        if(response != null){
          final storage = GetStorage();
          
          await storage.write('user', {
            'token': response.data.accessToken,
            'tokenType': response.data.tokenType,
          });

          await DatabaseService.recreateTasks();

          // INSERCION MASIVA DEL LISTADO DE TAREAS
          final cargarDataOffline = CargarDataOfline();

          final cargado = await cargarDataOffline.cargar();

          if (!cargado) {
            Get.snackbar(
              'Error',
              'No se pudieron cargar las tareas.',
            );

            return;
          }

          Get.offNamedUntil('/task-list',(route) => false);
        }else{
          Get.snackbar('Error', 'Ocurrió un error al iniciar sesión.');
        }
      }else{
        Get.snackbar('Error', 'Sin conexión a internet.');
      }

      isLoading.value = false;
    } catch (e) {
      Get.snackbar('Error', e.toString().replaceFirst('Exception: ', ''),); 
      isLoading.value = false;
    }
  }
}