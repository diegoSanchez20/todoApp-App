import 'dart:async';

import 'package:get/get.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class InternetService extends GetxController {

  final isConnected = false.obs;

  StreamSubscription<InternetStatus>? _subscription;

  @override
  void onInit() {
    super.onInit();

    _inicializarConexion();
  }

  Future<void> _inicializarConexion() async {

    // Primera comprobación
    final connected = await InternetConnection().hasInternetAccess;

    isConnected.value = connected;

    // Escuchar cambios
    _subscription = InternetConnection()
        .onStatusChange
        .listen((status) {

      isConnected.value =
          status == InternetStatus.connected;

    });
  }

  @override
  void onClose() {
    _subscription?.cancel();
    super.onClose();
  }
}