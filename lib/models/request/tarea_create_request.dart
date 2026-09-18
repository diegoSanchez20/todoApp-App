import 'dart:convert';

TareaCreateRequest tareaCreateRequestFromJson(String str) => TareaCreateRequest.fromJson(json.decode(str));

String tareaCreateRequestToJson(TareaCreateRequest data) => json.encode(data.toJson());

class TareaCreateRequest {
  String title;
  String description;

  TareaCreateRequest({
    required this.title,
    required this.description,
  });

  factory TareaCreateRequest.fromJson(Map<String, dynamic> json) => TareaCreateRequest(
    title: json["title"],
    description: json["description"],
  );

  Map<String, dynamic> toJson() => {
    "title": title,
    "description": description,
  };
}
