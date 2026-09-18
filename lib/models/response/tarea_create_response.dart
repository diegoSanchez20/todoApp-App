import 'dart:convert';

TareaCreateResponse tareaCreateResponseFromJson(String str) => TareaCreateResponse.fromJson(json.decode(str));

String tareaCreateResponseToJson(TareaCreateResponse data) => json.encode(data.toJson());

class TareaCreateResponse {
  DataTareaCreate data;

  TareaCreateResponse({
    required this.data,
  });

  factory TareaCreateResponse.fromJson(Map<String, dynamic> json) => TareaCreateResponse(
    data: DataTareaCreate.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "data": data.toJson(),
  };
}

class DataTareaCreate {
  int id;
  String title;
  String description;
  bool completed;

  DataTareaCreate({
    required this.id,
    required this.title,
    required this.description,
    required this.completed,
  });

  factory DataTareaCreate.fromJson(Map<String, dynamic> json) => DataTareaCreate(
    id: json["id"],
    title: json["title"],
    description: json["description"],
    completed: json["completed"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "description": description,
    "completed": completed,
  };
}
