import 'dart:convert';

TareaListResponse tareaListResponseFromJson(String str) => TareaListResponse.fromJson(json.decode(str));

String tareaListResponseToJson(TareaListResponse data) => json.encode(data.toJson());

class TareaListResponse {
  List<DataTareaList> data;
  MetaTask meta;

  TareaListResponse({
    required this.data,
    required this.meta,
  });

  factory TareaListResponse.fromJson(Map<String, dynamic> json) => TareaListResponse(
    data: List<DataTareaList>.from(json["data"].map((x) => DataTareaList.fromJson(x))),
    meta: MetaTask.fromJson(json["meta"]),
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
    "meta": meta.toJson(),
  };
}

class DataTareaList {
  int id;
  String title;
  String description;
  bool completed;
  String createdAt;
  String updatedAt;

  DataTareaList({
    required this.id,
    required this.title,
    required this.description,
    required this.completed,
    required this.createdAt,
    required this.updatedAt,
  });

  factory DataTareaList.fromJson(Map<String, dynamic> json) => DataTareaList(
    id: json["id"],
    title: json["title"],
    description: json["description"],
    completed: json["completed"] ?? false,
    createdAt: json["created_at"],
    updatedAt: json["updated_at"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "description": description,
    "completed": completed,
    "created_at": createdAt,
    "updated_at": updatedAt,
  };
}

class MetaTask {
  int total;
  int perPage;
  int currentPage;
  int lastPage;

  MetaTask({
    required this.total,
    required this.perPage,
    required this.currentPage,
    required this.lastPage,
  });

  factory MetaTask.fromJson(Map<String, dynamic> json) => MetaTask(
    total: json["total"],
    perPage: json["per_page"],
    currentPage: json["current_page"],
    lastPage: json["last_page"],
  );

  Map<String, dynamic> toJson() => {
    "total": total,
    "per_page": perPage,
    "current_page": currentPage,
    "last_page": lastPage,
  };
}
