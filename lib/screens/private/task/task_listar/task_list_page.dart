import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app/models/response/tarea_list_response.dart';
import 'package:todo_app/screens/private/task/task_listar/task_list_controller.dart';

class TaskListPage extends StatefulWidget {
  TaskListPage({super.key});

  @override
  State<TaskListPage> createState() => _TaskListPageState();
}

class _TaskListPageState extends State<TaskListPage> {
  TaskListarController con = TaskListarController();

  @override
  void initState() {
    super.initState();
    con.initData();
  }

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
      body: Obx(
        () => Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () => con.registrarTarea(),
                child: Text('Nuevo')
              ),
              SizedBox(height: 10),
              Expanded(
                child: ListView.separated(
                  itemCount: con.listTarea.length,
                  itemBuilder: (context, index) {
                    return _CardItem(
                      item: con.listTarea[index],
                      con:con,
                      index: index,
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {  
                    return Divider(color: Color.fromARGB(255, 100, 100, 100));
                  },
                ),
              )
            ],
          ),
        )
      ),
    );
  }
}

class _CardItem extends StatelessWidget {

  final DataTareaList item;
  final TaskListarController con;
  final int index;
  
  const _CardItem({
    required this.item, 
    required this.con, 
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Transform.scale(
          scale: 0.75,
          child: Switch(
            value: item.completed,
            onChanged: (value) {
              con.cambiarEstadoTareaCompletado(
                index,
              );
            },
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(item.title),
              Text(item.completed ? 'Completado' : 'Pendiente')
            ],
          ),
        ),
      ],
    );
  }
}