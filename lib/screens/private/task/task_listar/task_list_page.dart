import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app/models/response/tarea_list_response.dart';
import 'package:todo_app/screens/private/task/task_listar/task_list_controller.dart';
import 'package:todo_app/widgets/widgets.dart';

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
        title: const Text('Listar Tareas'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            onPressed: () => con.cerrarSesion(),
          ),
        ],
      ),
      body: Obx(
        () => Padding(
          padding: const EdgeInsets.all(8.0),
          child: con.isLoading.value
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const NotInternetBanner(),
                    Align(
                      alignment: AlignmentGeometry.centerLeft,
                      child: Row(
                        children: [
                          ElevatedButton(
                            onPressed: () => con.registrarTarea(),
                            child: const Text('Nuevo'),
                          ),
                          SizedBox(width: 5),
                          ElevatedButton(
                            onPressed: () => con.migrarTareas(),
                            child: const Text('Migrar Tareas Ofline'),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: con.refreshData,
                        child: ListView.separated(
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemCount: con.listTarea.length,
                          itemBuilder: (context, index) {
                            return _CardItem(
                              item: con.listTarea[index],
                              con: con,
                              index: index,
                            );
                          },
                          separatorBuilder: (context, index) {
                            return const Divider(color: Color.fromARGB(255,100,100,100));
                          },
                        ),
                      ),
                    ),
                    if(con.listTarea.isNotEmpty)
                    _Pagination(con: con),
                  ],
                ),
        ),
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
                item.id,
                item
              );
            },
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(item.title),
              Text(item.completed ? 'Completado' : 'Pendiente'),
            ],
          ),
        ),
        IconButton(
          icon: const Icon(Icons.edit),
          onPressed: () => con.editarTarea(item),
        ),
        IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () => con.eliminarTarea(item),
        ),
      ],
    );
  }
}

class _Pagination extends StatelessWidget {

  final TaskListarController con;

  const _Pagination({
    required this.con
  });

  @override
  Widget build(BuildContext context) {
    return CustomPagination(
      onPageChange: (number){
        // con.pageNumber.value = number!;
        // con.getAll();
        con.cambiarPagina(number);
      }, 
      totalPage: (con.total / con.pageSize.value).ceil(), 
      show: (con.total / con.pageSize.value).floor() - 1, 
      currentPage: con.pageNumber.value
    );
  }
}