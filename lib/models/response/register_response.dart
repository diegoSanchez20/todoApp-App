import 'dart:convert';

RegisterResponse registerResponseFromJson(String str) => RegisterResponse.fromJson(json.decode(str));

class RegisterResponse {
  DataRegister data;

  RegisterResponse({
    required this.data,
  });

  factory RegisterResponse.fromJson(Map<String, dynamic> json) => RegisterResponse(
    data: DataRegister.fromJson(json["data"]),
  );
}

class DataRegister {
  int id;
  String name;
  String email;

  DataRegister({
    required this.id,
    required this.name,
    required this.email,
  });

  factory DataRegister.fromJson(Map<String, dynamic> json) => DataRegister(
    id: json["id"],
    name: json["name"],
    email: json["email"],
  );
}
