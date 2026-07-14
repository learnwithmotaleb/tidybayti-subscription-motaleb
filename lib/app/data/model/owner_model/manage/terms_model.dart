import 'dart:convert';

class TermsModel {
  int? statusCode;
  bool? success;
  String? message;
  TermsData? data;

  TermsModel({
    this.statusCode,
    this.success,
    this.message,
    this.data,
  });

  factory TermsModel.fromRawJson(String str) => TermsModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory TermsModel.fromJson(Map<String, dynamic> json) => TermsModel(
    statusCode: json["statusCode"],
    success: json["success"],
    message: json["message"],
    data: json["data"] == null ? null : TermsData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "statusCode": statusCode,
    "success": success,
    "message": message,
    "data": data?.toJson(),
  };
}

class TermsData {
  String? id;
  String? description;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;

  TermsData({
    this.id,
    this.description,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory TermsData.fromRawJson(String str) => TermsData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory TermsData.fromJson(Map<String, dynamic> json) => TermsData(
    id: json["_id"],
    description: json["description"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "description": description,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "__v": v,
  };
}
