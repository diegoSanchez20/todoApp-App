import 'dart:convert';

TareaCreateUpdateRequest tareaCreateUpdateRequestFromJson(String str) => TareaCreateUpdateRequest.fromJson(json.decode(str));

String tareaCreateUpdateRequestToJson(TareaCreateUpdateRequest data) => json.encode(data.toJson());

class TareaCreateUpdateRequest {
  String title;
  String description;

  TareaCreateUpdateRequest({
    required this.title,
    required this.description,
  });

  factory TareaCreateUpdateRequest.fromJson(Map<String, dynamic> json) => TareaCreateUpdateRequest(
    title: json["title"],
    description: json["description"],
  );

  Map<String, dynamic> toJson() => {
    "title": title,
    "description": description,
  };
}
