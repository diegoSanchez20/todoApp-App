import 'dart:convert';
import 'package:todo_app/env/env.dart';
import 'package:todo_app/interceptors/interceptor_http.dart';
import 'package:todo_app/models/response_api.dart';

class CategoryService{
  final String _url = Enviroment.apiUrl;
  final String api = '/api/task';

  final InterceptorHttp _client = InterceptorHttp();

   Future<ResponseApi> getAll(String name, int pageSize,int pageNumber, String idusuario, {String idLocalidad = ''}) async {
   
    Uri url = Uri.https(_url, '$api/getAll');
    String bodyParams = jsonEncode({
      'name': name, 
      'pageSize': pageSize, 
      'pageNumber': pageNumber, 
      'idusuario':idusuario,
      'idLocalidad':idLocalidad
    });

    return await _client.handleResponse(
      _client.post(url, body: bodyParams),
    ); 
  }

  Future<ResponseApi> getId(String id) async {

    Uri url = Uri.https(_url, '$api/$id');

    return await _client.handleResponse(
      _client.get(url),
    );
  }

  // Future<ResponseApi> create(Almacen almacen) async {
    
  //   Uri url = Uri.https(_url, '$api/create');
  //   String bodyParams = json.encode(almacen);
    
  //   return await _client.handleResponse(
  //     _client.post(url,body: bodyParams),
  //   );
  // }

  // Future<ResponseApi> update(Almacen almacen) async {

  //   Uri url = Uri.https(_url, '$api/update/${almacen.idalmacen}');
  //   String bodyParams = json.encode(almacen);
    
  //   return await _client.handleResponse(
  //     _client.put(url,body: bodyParams),
  //   );
  // }

  // Future<ResponseApi> habilitar(Almacen almacen) async {
   
  //   Uri url = Uri.https(_url, '$api/habilitar');
  //   String bodyParams = json.encode(almacen);

  //   return await _client.handleResponse(
  //     _client.put(url,body: bodyParams),
  //   );
  // }

  // Future<ResponseApi> deshabilitar(Almacen almacen) async {
    
  //   Uri url = Uri.https(_url, '$api/deshabilitar');
  //   String bodyParams = json.encode(almacen);

  //   return await _client.handleResponse(
  //     _client.put(url,body: bodyParams),
  //   );
  // }
}