import 'dart:convert';
import 'package:todo_app/env/env.dart';
import 'package:todo_app/interceptors/interceptor_http.dart';
import 'package:todo_app/models/request/tarea_create_update_request.dart';
import 'package:todo_app/models/response/tarea_create_update_response.dart';
import 'package:todo_app/models/response/tarea_list_response.dart';

class TaskService{
  final String _url = Enviroment.apiUrl;

  final InterceptorHttp _client = InterceptorHttp();

   Future<TareaListResponse?> getAll(int pageSize,int pageNumber) async {
   
    final url = Uri.parse('$_url/tasks?per_page=$pageSize&page=$pageNumber');
    
    final response = await _client.get(url);

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      return TareaListResponse.fromJson(responseData);
    }

    return null; 
  }

  Future<TareaCreateUpdateResponse?> create(TareaCreateUpdateRequest tarea) async {
    final url = Uri.parse('$_url/tasks');
    final body = json.encode(tarea);
    
    final response = await _client.post(url,body: body);

    if (response.statusCode == 201) {
      final responseData = jsonDecode(response.body);
      return TareaCreateUpdateResponse.fromJson(responseData);
    }

    return null;
  }

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