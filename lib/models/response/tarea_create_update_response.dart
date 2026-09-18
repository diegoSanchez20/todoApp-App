import 'dart:convert';

TareaCreateUpdateResponse tareaCreateUpdateResponseFromJson(String str) => TareaCreateUpdateResponse.fromJson(json.decode(str));

String tareaCreateUpdateResponseToJson(TareaCreateUpdateResponse data) => json.encode(data.toJson());

class TareaCreateUpdateResponse {
  DataTareaCreateUpdate data;

  TareaCreateUpdateResponse({
    required this.data,
  });

  factory TareaCreateUpdateResponse.fromJson(Map<String, dynamic> json) => TareaCreateUpdateResponse(
    data: DataTareaCreateUpdate.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "data": data.toJson(),
  };
}

class DataTareaCreateUpdate {
  int id;
  String title;
  String description;
  bool completed;

  DataTareaCreateUpdate({
    required this.id,
    required this.title,
    required this.description,
    required this.completed,
  });

  factory DataTareaCreateUpdate.fromJson(Map<String, dynamic> json) => DataTareaCreateUpdate(
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
