import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:todo_app/env/env.dart';

class AuthService{

  final String _url = Enviroment.apiUrl;


  Future<String?> iniciarSesion(String email, String password)async{
    String bodyParams = jsonEncode({
      'email': email, 
      'password': password, 
    });

    final headers = {
      'IsDash': 'apk',
      'Content-Type': 'application/json',
    };

    Uri url = Uri.parse('$_url/login');

    final response = await http.post(url, headers: headers, body: bodyParams);

    if(response.statusCode == 200){
      return '';
    }else{
      return null;
    }
  }

  Future<String?> register(String email, String password, String name)async{
    String bodyParams = jsonEncode({
      'email': email, 
      'password': password, 
      'name':name
    });

    final headers = {
      'IsDash': 'apk',
      'Content-Type': 'application/json',
    };

    Uri url = Uri.parse('$_url/register');

    final response = await http.post(url, headers: headers, body: bodyParams);

    if(response.statusCode == 200){
      return '';
    }else{
      return null;
    }
  }

}