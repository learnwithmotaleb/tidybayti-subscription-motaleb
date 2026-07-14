import 'dart:convert';

class GetRoomModel {
  int? statusCode;
  bool? success;
  String? message;
  HouseRoomData? data;

  GetRoomModel({
    this.statusCode,
    this.success,
    this.message,
    this.data,
  });

  factory GetRoomModel.fromRawJson(String str) => GetRoomModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetRoomModel.fromJson(Map<String, dynamic> json) => GetRoomModel(
    statusCode: json["statusCode"],
    success: json["success"],
    message: json["message"],
    data: json["data"] == null ? null : HouseRoomData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "statusCode": statusCode,
    "success": success,
    "message": message,
    "data": data?.toJson(),
  };
}

class HouseRoomData {
  int? count;
  List<Room>? rooms;

  HouseRoomData({
    this.count,
    this.rooms,
  });

  factory HouseRoomData.fromRawJson(String str) => HouseRoomData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory HouseRoomData.fromJson(Map<String, dynamic> json) => HouseRoomData(
    count: json["count"],
    rooms: json["rooms"] == null ? [] : List<Room>.from(json["rooms"]!.map((x) => Room.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "count": count,
    "rooms": rooms == null ? [] : List<dynamic>.from(rooms!.map((x) => x.toJson())),
  };
}

class Room {
  String? id;
  String? user;
  String? house;
  String? name;
  String? roomImage;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;

  Room({
    this.id,
    this.user,
    this.house,
    this.name,
    this.roomImage,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory Room.fromRawJson(String str) => Room.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Room.fromJson(Map<String, dynamic> json) => Room(
    id: json["_id"],
    user: json["user"],
    house: json["house"],
    name: json["name"],
    roomImage: json["roomImage"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "user": user,
    "house": house,
    "name": name,
    "roomImage": roomImage,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "__v": v,
  };
}
