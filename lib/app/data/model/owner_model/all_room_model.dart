import 'dart:convert';

class AllRoomModel {
  int? statusCode;
  bool? success;
  String? message;
  RoomList? data;

  AllRoomModel({
    this.statusCode,
    this.success,
    this.message,
    this.data,
  });

  factory AllRoomModel.fromRawJson(String str) => AllRoomModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AllRoomModel.fromJson(Map<String, dynamic> json) => AllRoomModel(
    statusCode: json["statusCode"],
    success: json["success"],
    message: json["message"],
    data: json["data"] == null ? null : RoomList.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "statusCode": statusCode,
    "success": success,
    "message": message,
    "data": data?.toJson(),
  };
}

class RoomList {
  int? count;
  List<Room>? rooms;

  RoomList({
    this.count,
    this.rooms,
  });

  factory RoomList.fromRawJson(String str) => RoomList.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory RoomList.fromJson(Map<String, dynamic> json) => RoomList(
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
