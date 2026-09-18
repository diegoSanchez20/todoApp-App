import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:todo_app/database/database.dart';
import 'package:todo_app/routes/routes.dart';
import 'package:todo_app/services/internet_service.dart';
import 'package:todo_app/theme/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await GetStorage.init();

  await DatabaseService.database;

  Get.put(InternetService());
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'App Tareas',
      debugShowCheckedModeBanner: false,
      getPages: getPages,
      theme: AppTheme.lightTheme,
    );
  }
}