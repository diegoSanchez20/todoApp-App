import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';

class InterceptorHttp extends http.BaseClient {
  final http.Client _inner = http.Client();

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {

    final storage = GetStorage();
    final user = storage.read('user');

    final accessToken = user is Map
        ? user['access_token'] ?? user['token']
        : null;

    if (accessToken is String && accessToken.isNotEmpty) {
      request.headers['Authorization'] = 'Bearer $accessToken';
    }

    request.headers['Content-Type'] = 'application/json';
    request.headers['Accept'] = 'application/json';

    final response = await _inner.send(request);

    if (response.statusCode >= 400) {
      final body = await response.stream.bytesToString();
      final message = _getErrorMessage(body);

      Get.snackbar(
        'Error',
        message,
        duration: const Duration(seconds: 3),
      );

      if (response.statusCode == 401 &&
          !request.url.path.endsWith('/logout')) {
        await storage.remove('user');
        Get.offNamedUntil('/', (route) => false);
      }

      return http.StreamedResponse(
        Stream.value(utf8.encode(body)),
        response.statusCode,
        headers: response.headers,
        request: response.request,
        isRedirect: response.isRedirect,
        persistentConnection: response.persistentConnection,
        reasonPhrase: response.reasonPhrase,
      );
    }

    return response;
  }

  String _getErrorMessage(String body) {
    const defaultMessage = 'Ocurrió un error';

    try {
      final data = jsonDecode(body);
      if (data is! Map<String, dynamic>) return defaultMessage;

      final message = data['message'];
      if (message is String && message.isNotEmpty) return message;

      final errors = data['errors'];
      if (errors is Map) {
        for (final value in errors.values) {
          if (value is List && value.isNotEmpty) return value.first.toString();
          if (value is String && value.isNotEmpty) return value;
        }
      }
    } catch (_) {
      if (body.trim().isNotEmpty) return body.trim();
    }

    return defaultMessage;
  }
}