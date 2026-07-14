import 'dart:convert';

class MyHouseModel {
  int? statusCode;
  bool? success;
  String? message;
  MyHouseData? data;

  MyHouseModel({
    this.statusCode,
    this.success,
    this.message,
    this.data,
  });

  factory MyHouseModel.fromRawJson(String str) => MyHouseModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory MyHouseModel.fromJson(Map<String, dynamic> json) => MyHouseModel(
    statusCode: json["statusCode"],
    success: json["success"],
    message: json["message"],
    data: json["data"] == null ? null : MyHouseData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "statusCode": statusCode,
    "success": success,
    "message": message,
    "data": data?.toJson(),
  };
}

class MyHouseData {
  int? count;
  List<House>? houses;

  MyHouseData({
    this.count,
    this.houses,
  });

  factory MyHouseData.fromRawJson(String str) => MyHouseData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory MyHouseData.fromJson(Map<String, dynamic> json) => MyHouseData(
    count: json["count"],
    houses: json["houses"] == null ? [] : List<House>.from(json["houses"]!.map((x) => House.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "count": count,
    "houses": houses == null ? [] : List<dynamic>.from(houses!.map((x) => x.toJson())),
  };
}

class House {
  String? id;
  String? user;
  String? name;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;

  House({
    this.id,
    this.user,
    this.name,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory House.fromRawJson(String str) => House.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory House.fromJson(Map<String, dynamic> json) => House(
    id: json["_id"],
    user: json["user"],
    name: json["name"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "user": user,
    "name": name,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "__v": v,
  };
}
