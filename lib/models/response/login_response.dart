import 'dart:convert';

LoginResponse loginResponseFromJson(String str) => LoginResponse.fromJson(json.decode(str));


class LoginResponse {
  DataRegister data;

  LoginResponse({
    required this.data,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
    data: DataRegister.fromJson(json["data"]),
  );
}

class DataRegister {
  String accessToken;
  String tokenType;
  int expiresIn;
UserRegister user;

  DataRegister({
    required this.accessToken,
    required this.tokenType,
    required this.expiresIn,
    required this.user,
  });

  factory DataRegister.fromJson(Map<String, dynamic> json) => DataRegister(
    accessToken: json["access_token"],
    tokenType: json["token_type"],
    expiresIn: json["expires_in"],
    user: UserRegister.fromJson(json["user"]),
  );
}

class UserRegister {
  int id;
  String name;
  String email;

  UserRegister({
    required this.id,
    required this.name,
    required this.email,
  });

  factory UserRegister.fromJson(Map<String, dynamic> json) => UserRegister(
    id: json["id"],
    name: json["name"],
    email: json["email"],
  );
}
