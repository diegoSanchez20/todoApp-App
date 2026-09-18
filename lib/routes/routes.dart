import 'package:get/get.dart';
import 'package:todo_app/middleware/auth_middleware.dart';
import 'package:todo_app/screens/auth/login/login_page.dart';
import 'package:todo_app/screens/auth/register/register_page.dart';
import 'package:todo_app/screens/private/task/task_crear_editar/task_create_edit_page.dart';
import 'package:todo_app/screens/private/task/task_listar/task_list_page.dart';

List<GetPage<dynamic>> getPages = [
  GetPage(
    name: '/', 
    page: () => LoginPage()
  ),
  GetPage(
    name: '/register', 
    page: () => RegisterPage()
  ),
  GetPage(
    name: '/task-crear-editar', 
    page: () => TaskCreateEditPage(),
    middlewares: [
      AuthMiddleware()
    ]
  ),
  GetPage(
    name: '/task-list', 
    page: () => TaskListPage(),
    middlewares: [
      AuthMiddleware()
    ]
  ),
];