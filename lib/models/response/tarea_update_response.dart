import 'dart:convert';

TareaUpdateResponse tareaUpdateResponseFromJson(String str) => TareaUpdateResponse.fromJson(json.decode(str));

String tareaUpdateResponseToJson(TareaUpdateResponse data) => json.encode(data.toJson());

class TareaUpdateResponse {
  DataTareaUpdate data;

  TareaUpdateResponse({
    required this.data,
  });

  factory TareaUpdateResponse.fromJson(Map<String, dynamic> json) => TareaUpdateResponse(
    data: DataTareaUpdate.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "data": data.toJson(),
  };
}

class DataTareaUpdate {
  int id;
  String title;
  String description;
  bool completed;

  DataTareaUpdate({
    required this.id,
    required this.title,
    required this.description,
    required this.completed,
  });

  factory DataTareaUpdate.fromJson(Map<String, dynamic> json) => DataTareaUpdate(
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
