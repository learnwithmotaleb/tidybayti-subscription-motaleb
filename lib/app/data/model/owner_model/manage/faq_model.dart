import 'dart:convert';

class FaqModel {
  int? statusCode;
  bool? success;
  String? message;
  List<FaqList>? data;

  FaqModel({
    this.statusCode,
    this.success,
    this.message,
    this.data,
  });

  factory FaqModel.fromRawJson(String str) => FaqModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory FaqModel.fromJson(Map<String, dynamic> json) => FaqModel(
    statusCode: json["statusCode"],
    success: json["success"],
    message: json["message"],
    data: json["data"] == null ? [] : List<FaqList>.from(json["data"]!.map((x) => FaqList.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "statusCode": statusCode,
    "success": success,
    "message": message,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class FaqList {
  String? id;
  String? description;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;
  String? question;

  FaqList({
    this.id,
    this.description,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.question,
  });

  factory FaqList.fromRawJson(String str) => FaqList.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory FaqList.fromJson(Map<String, dynamic> json) => FaqList(
    id: json["_id"],
    description: json["description"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    v: json["__v"],
    question: json["question"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "description": description,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "__v": v,
    "question": question,
  };
}
