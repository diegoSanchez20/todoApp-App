class ResponseApi {
  ResponseApi({
    this.message,
    this.success,
    this.status
  });

  String? message;
  int? status;
  bool? success;
  dynamic data;

  ResponseApi.fromJson(Map<String, dynamic> json) {
    message = json["message"];
    success = json["success"];
    status = json["status"];
    data = json['data'] is int ? json["data"].toString() : json["data"];
  }

  Map<String, dynamic> toJson() =>{
    "message": message, 
    "status":status,
    "success": success, 
    "data": data
  };
}
