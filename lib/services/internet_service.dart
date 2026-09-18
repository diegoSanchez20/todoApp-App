import 'dart:async';

import 'package:get/get.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class InternetService extends GetxController {
  final isConnected = true.obs;

  StreamSubscription<InternetStatus>? _subscription;

  @override
  void onInit() {
    super.onInit();

    verificarConexion();

    _subscription = InternetConnection().onStatusChange.listen(
      (status) {
        isConnected.value = status == InternetStatus.connected;
      },
    );
  }

  Future<void> verificarConexion() async {
    final connected = await InternetConnection().hasInternetAccess;

    isConnected.value = connected;
  }

  @override
  void onClose() {
    _subscription?.cancel();
    super.onClose();
  }
}