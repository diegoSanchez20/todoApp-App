import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import 'package:get_storage/get_storage.dart';
import 'package:todo_app/models/response/cerrar_sesion_response.dart';
import 'package:todo_app/services/auth_service.dart';
import 'package:todo_app/services/internet_service.dart';

class TaskListarController extends GetxController{
  AuthService authService = AuthService();
  final internetService = Get.find<InternetService>();
  final isLoading = false.obs;

  Future<void> cerrarSesion()async{
    if ( isLoading.value) return;
    isLoading.value = true;
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
    isLoading.value = false;
  }
}