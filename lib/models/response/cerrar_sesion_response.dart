import 'dart:convert';

CerrarSesionResponse cerrarSesionResponseFromJson(String str) => CerrarSesionResponse.fromJson(json.decode(str));

class CerrarSesionResponse {
  String message;

  CerrarSesionResponse({
    required this.message,
  });

  factory CerrarSesionResponse.fromJson(Map<String, dynamic> json) => CerrarSesionResponse(
    message: json["message"],
  );
}