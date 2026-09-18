import 'dart:convert';

TareaCompleteResponse tareaCompleteResponseFromJson(String str) => TareaCompleteResponse.fromJson(json.decode(str));

String tareaCompleteResponseToJson(TareaCompleteResponse data) => json.encode(data.toJson());

class TareaCompleteResponse {
  DataTareaComplete data;

  TareaCompleteResponse({
    required this.data,
  });

  factory TareaCompleteResponse.fromJson(Map<String, dynamic> json) => TareaCompleteResponse(
    data: DataTareaComplete.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "data": data.toJson(),
  };
}

class DataTareaComplete {
  int id;
  String title;
  String description;
  bool completed;

  DataTareaComplete({
    required this.id,
    required this.title,
    required this.description,
    required this.completed,
  });

  factory DataTareaComplete.fromJson(Map<String, dynamic> json) => DataTareaComplete(
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
