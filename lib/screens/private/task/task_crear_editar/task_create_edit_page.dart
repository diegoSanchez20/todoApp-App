import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app/screens/private/task/task_crear_editar/task_create_edit_controller.dart';
import 'package:todo_app/widgets/custom_elevated_buttom.dart';
import 'package:todo_app/widgets/custom_text.dart';
import 'package:todo_app/widgets/not_internet_banner.dart';

class TaskCreateEditPage extends StatelessWidget {
  TaskCreateEditPage({super.key});

  TaskCreateEditController con = TaskCreateEditController();

  @override
  Widget build(BuildContext context) {

    con.initData();

    return Scaffold(
      appBar: AppBar(
        title: Text(con.tarea == null ? 'Crear Tareas' : 'Editar Tareas'),
      ),
      body: Column(
        children: [
          const NotInternetBanner(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Obx(
                () => SingleChildScrollView(
                  child: Form(
                    key: con.formKey,
                    child: Column(
                      spacing: 10,
                      children: [
                        CustomText(
                          controller: con.titleController,
                          hintText: 'Ingrese el título',
                          label: 'Título',
                          validator: (value) {
                            if(value == '' || value == null){
                              return 'Ingrese el título.';
                            }
                            return null;
                          },
                        ),
                       CustomText(
                          controller: con.decriptionController,
                          hintText: 'Ingrese la descripción',
                          label: 'Descripción',
                          validator: (value) {
                            if(value == '' || value == null){
                              return 'Ingrese la descripción.';
                            }
                            return null;
                          },
                        ),
                        CustomElevatedButton(
                          title: 'Guardar',
                          isLoading: con.isLoading.value,
                          onPressed: () => !con.isLoading.value 
                            ? con.guardarTask()
                            : null,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}