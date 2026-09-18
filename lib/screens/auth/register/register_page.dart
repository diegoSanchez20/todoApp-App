import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app/screens/auth/register/register_controller.dart';
import 'package:todo_app/utils/expresion_regular.dart';
import 'package:todo_app/widgets/widgets.dart';

class RegisterPage extends StatelessWidget {
  
  RegisterPage({super.key});

  RegisterController con = RegisterController();

  @override
  Widget build(BuildContext context) {

    con.context = context;

    return Scaffold(
      appBar: AppBar(
        title: Text('Registrar'),
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
                          controller: con.nameController,
                          hintText: 'Ingrese sus nombres Completos',
                          label: 'Nombres Completos',
                          validator: (value) {
                            if(value == '' || value == null){
                              return 'Ingrese sus nombres completos.';
                            }
                            return null;
                          },
                        ),
                        CustomText(
                          controller: con.emailController,
                          hintText: 'Ingrese el email',
                          keyboardType: TextInputType.emailAddress,
                          label: 'Email',
                          validator: (value) {
                            if(value == '' || value == null){
                              return 'Ingrese el email.';
                            }
                            if(!ExprexionRegular().formatoCorreo.hasMatch(value)){
                              return 'El email o es válido';
                            }
                            return null;
                          },
                        ),
                        CustomText(
                          controller: con.passwordController,
                          hintText: 'Ingrese la contraseña',
                          label: 'Contraseña',
                          usePassword: true,
                          obscureText: con.obscureText.value,
                          onTapSuffixIcon: () => con.obscureText.value = !con.obscureText.value,
                          validator: (value) {
                            if(value == '' || value == null){
                              return 'Ingrese la contraseña.';
                            }
                            if(value.length <= 8){
                              return 'La contraseña debe tener mas de 8 caracteres';
                            }
                            
                            return null;
                          },
                        ),
                        CustomElevatedButton(
                          title: 'Registrar',
                          isLoading: con.isLoading.value,
                          onPressed: () => !con.isLoading.value 
                            ? con.registrar()
                            : null,
                        ),
                        GestureDetector(
                          onTap: () => Get.toNamed('login'),
                          child: Text('¿Ya tienes una cuenta? Haz clic aquí'),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}