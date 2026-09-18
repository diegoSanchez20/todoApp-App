import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:todo_app/models/response_api.dart';

class InterceptorHttp extends http.BaseClient{
  final http.Client _inner = http.Client();

   @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async{
    final user = null;
    if (user != null && user['token'] != null) {
      request.headers['x-token'] = user['token'];
    }
    request.headers['Content-type'] = 'application/json';

    final response = await _inner.send(request);

    return response;
  }

  Future<ResponseApi> handleResponse(Future<http.Response> futureRes) async{
    final res = await futureRes;
    final data = json.decode(res.body);
    ResponseApi responseApi = ResponseApi.fromJson(data);
    return responseApi;
  }
}