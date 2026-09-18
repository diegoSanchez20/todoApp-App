import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app/services/internet_service.dart';

class NotInternetBanner extends StatelessWidget {
  const NotInternetBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final internetService = Get.find<InternetService>();

    return Obx(() {
      if (internetService.isConnected.value) {
        return const SizedBox.shrink();
      }

      return Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 10,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        decoration: BoxDecoration(
          color: Colors.red.shade600,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 7,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.wifi_off_rounded,
              color: Colors.white,
              size: 20,
            ),

            SizedBox(width: 8),

            Flexible(
              child: Text(
                'Usted no cuenta con conexión a Internet',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  decoration: TextDecoration.none,
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}