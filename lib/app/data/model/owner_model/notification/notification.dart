import 'dart:convert';

class NotificationModel {
  int? statusCode;
  bool? success;
  String? message;
  List<NotificationData>? data; // ✅ `data` is a List<NotificationData>

  NotificationModel({
    this.statusCode,
    this.success,
    this.message,
    this.data,
  });

  factory NotificationModel.fromRawJson(String str) =>
      NotificationModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      NotificationModel(
        statusCode: json["statusCode"],
        success: json["success"],
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<NotificationData>.from(
            json["data"].map((x) => NotificationData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
    "statusCode": statusCode,
    "success": success,
    "message": message,
    "data": data == null
        ? []
        : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class NotificationData {
  String? id;
  String? toId;
  String? title;
  String? message;
  bool? isRead;
  DateTime? createdAt;
  DateTime? updatedAt;

  NotificationData({
    this.id,
    this.toId,
    this.title,
    this.message,
    this.isRead,
    this.createdAt,
    this.updatedAt,
  });

  factory NotificationData.fromRawJson(String str) =>
      NotificationData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory NotificationData.fromJson(Map<String, dynamic> json) =>
      NotificationData(
        id: json["_id"],
        toId: json["toId"],
        title: json["title"],
        message: json["message"],
        isRead: json["isRead"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "toId": toId,
    "title": title,
    "message": message,
    "isRead": isRead,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
  };
}
