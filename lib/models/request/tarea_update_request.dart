import 'dart:convert';

TareaUpdateRequest tareaUpdateRequestFromJson(String str) => TareaUpdateRequest.fromJson(json.decode(str));

String tareaUpdateRequestToJson(TareaUpdateRequest data) => json.encode(data.toJson());

class TareaUpdateRequest {
  String title;
  String description;
  bool completed;

  TareaUpdateRequest({
    required this.title,
    required this.description,
    required this.completed,
  });

  factory TareaUpdateRequest.fromJson(Map<String, dynamic> json) => TareaUpdateRequest(
    title: json["title"],
    description: json["description"],
    completed: json["completed"],
  );

  Map<String, dynamic> toJson() => {
    "title": title,
    "description": description,
    "completed": completed,
  };
}
