import 'dart:convert';
import 'package:todo_app/env/env.dart';
import 'package:todo_app/interceptors/interceptor_http.dart';
import 'package:todo_app/models/request/tarea_create_request.dart';
import 'package:todo_app/models/request/tarea_update_request.dart';
import 'package:todo_app/models/response/tarea_complete_response.dart';
import 'package:todo_app/models/response/tarea_create_response.dart';
import 'package:todo_app/models/response/tarea_list_response.dart';
import 'package:todo_app/models/response/tarea_update_response.dart';

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

  Future<TareaCreateResponse?> create(TareaCreateRequest tarea) async {
    final url = Uri.parse('$_url/tasks');
    final body = json.encode(tarea);
    
    final response = await _client.post(url,body: body);

    if (response.statusCode == 201) {
      final responseData = jsonDecode(response.body);
      return TareaCreateResponse.fromJson(responseData);
    }

    return null;
  }

  Future<TareaCompleteResponse?> completeId(int id) async {

    final url = Uri.parse('$_url/tasks/$id/complete');
    
    final response = await _client.patch(url);

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      return TareaCompleteResponse.fromJson(responseData);
    }

    return null;
  }

  Future<TareaUpdateResponse?> edit(TareaUpdateRequest tarea, int id) async {

    final url = Uri.parse('$_url/tasks/$id');
    final body = json.encode(tarea);
    
    final response = await _client.put(url,body: body);

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      return TareaUpdateResponse.fromJson(responseData);
    }

    return null;
  }

  Future<bool> delete(int taskId) async {

    final url = Uri.parse('$_url/tasks/$taskId');
    
    final response = await _client.delete(url);

    if (response.statusCode == 204) {
      return true;
    }

    return false;
  }
}