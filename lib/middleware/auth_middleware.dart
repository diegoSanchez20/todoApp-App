import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    final storage = GetStorage();

    final user = storage.read('user');

    if (user == null) {
      return const RouteSettings(name: '/');
    }

    return null;
  }
}