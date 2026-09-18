import 'package:flutter/material.dart';
import 'package:todo_app/screens/private/task/task_listar/task_list_controller.dart';

class TaskListPage extends StatelessWidget {
  TaskListPage({super.key});

  TaskListarController con = TaskListarController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task Listado'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout_rounded),
            onPressed: () => con.cerrarSesion() , 
          )
        ],
      ),
    );
  }
}