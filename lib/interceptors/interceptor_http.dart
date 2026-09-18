import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';

class InterceptorHttp extends http.BaseClient{
  final http.Client _inner = http.Client();

   @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async{
    final user = GetStorage().read('user');
    final accessToken = user is Map
        ? user['access_token'] ?? user['token']
        : null;

    if (accessToken is String && accessToken.isNotEmpty) {
      request.headers['Authorization'] = 'Bearer $accessToken';
    }
    request.headers['Content-Type'] = 'application/json';

    final response = await _inner.send(request);

    if (response.statusCode == 401 && !request.url.path.endsWith('/logout')) {
      final storage = GetStorage();
      storage.remove('user');
      Get.offNamedUntil('/',(route) => false);
    }

    return response;
  }
}