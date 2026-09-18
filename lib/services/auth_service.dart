import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:todo_app/env/env.dart';
import 'package:todo_app/interceptors/interceptor_http.dart';
import 'package:todo_app/models/response/cerrar_sesion_response.dart';
import 'package:todo_app/models/response/login_response.dart';
import 'package:todo_app/models/response/register_response.dart';


class AuthService{

  final String _url = Enviroment.apiUrl;
  final InterceptorHttp _client = InterceptorHttp();


  Future<LoginResponse?> login(String email, String password)async{
    
    String body = jsonEncode({
      'email': email, 
      'password': password, 
    });

    final headers = {
      'IsDash': 'apk',
      'Content-Type': 'application/json',
    };

    Uri url = Uri.parse('$_url/login');

    final response = await http.post(url, headers: headers, body: body);

    if(response.statusCode == 200 || response.statusCode == 201){
      final responseData = jsonDecode(response.body);
      return LoginResponse.fromJson(responseData);
    }else{
      return null;
    }
  }

  Future<RegisterResponse?> register(String email, String password, String name)async{
    final body = jsonEncode({
      'email': email, 
      'password': password, 
      'name':name
    });

    final headers = {
      'IsDash': 'apk',
      'Content-Type': 'application/json',
    };

    final url = Uri.parse('$_url/register');

    final response = await http.post(url, headers: headers, body: body);

    if(response.statusCode == 200 || response.statusCode == 201){
      final responseData = jsonDecode(response.body);
      return RegisterResponse.fromJson(responseData);
    }else{
      return null;
    }
  }

  Future<CerrarSesionResponse?> cerrarSesion() async {
    final url = Uri.parse('$_url/logout');
    final response = await _client.post(url);

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      return CerrarSesionResponse.fromJson(responseData);
    }

    return null;
  }

}