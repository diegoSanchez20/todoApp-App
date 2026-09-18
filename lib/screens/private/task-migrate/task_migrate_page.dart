import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app/models/response/tarea_list_response.dart';
import 'package:todo_app/screens/private/task-migrate/task_migrate_controller.dart';
import 'package:todo_app/widgets/not_internet_banner.dart';

class TaskMigratePage extends StatefulWidget {
  const TaskMigratePage({super.key});

  @override
  State<TaskMigratePage> createState() => _TaskMigratePageState();
}

class _TaskMigratePageState extends State<TaskMigratePage> {

  TaskMigrateController con = TaskMigrateController();

  @override
  void initState() {
    super.initState();
    con.initData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Migrar Tareas Ofline'),
      ),
      body: Obx(
        () => Padding(
          padding: const EdgeInsets.all(8.0),
          child: con.isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  const NotInternetBanner(),
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
                ],
              )
        )
      ),
    );
  }
}

class _CardItem extends StatelessWidget {
  final DataTareaList item;
  final TaskMigrateController con;
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
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(item.title),
              Text(item.completed ? 'Completado' : 'Pendiente'),
            ],
          ),
        ),
        ElevatedButton(
          child: Text('Migrar'),
          onPressed: () => con.migrarTarea(item),
        ),
      ],
    );
  }
}