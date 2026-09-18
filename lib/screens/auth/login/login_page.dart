import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app/screens/auth/login/login_controller.dart';
import 'package:todo_app/utils/expresion_regular.dart';
import 'package:todo_app/widgets/widgets.dart';

class LoginPage extends StatelessWidget {
  
  LoginPage({super.key});

  LoginController con = LoginController();

  @override
  Widget build(BuildContext context) {

    con.context = context;

    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
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
                          controller: con.emailController,
                          hintText: 'Ingrese el email',
                          keyboardType: TextInputType.emailAddress,
                          label: 'Email',
                          validator: (value) {
                            if(value == '' || value == null){
                              return 'Ingrese el email.';
                            }
                            if(!ExprexionRegular().formatoCorreo.hasMatch(value)){
                              return 'El email no es válido.';
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
                              return 'La contraseña debe tener más de 8 caracteres.';
                            }
                            
                            return null;
                          },
                        ),
                        CustomElevatedButton(
                          isLoading: con.isLoading.value,
                          onPressed: () => !con.isLoading.value 
                            ? con.iniciarSesion()
                            : null,
                        ),
                        GestureDetector(
                          onTap: () => Get.toNamed('register'),
                          child: Text('¿No tienes un usuario? Haz clic aquí'),
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