import 'dart:convert';

class SingleRoomModel {
  String? id;
  String? user;
  Room? room;
  AssignedTo? assignedTo;
  String? taskName;
  String? recurrence;
  String? startDateStr;
  String? startTimeStr;
  DateTime? startDateTime;
  DateTime? endDateTime;
  String? endTimeStr;
  String? endDateStr;
  int? duration;
  String? dayOfWeek;
  String? taskDetails;
  String? additionalMessage;
  String? status;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? recurrenceRule;
  String? recurrenceStr;

  SingleRoomModel({
    this.id,
    this.user,
    this.room,
    this.assignedTo,
    this.taskName,
    this.recurrence,
    this.startDateStr,
    this.startTimeStr,
    this.startDateTime,
    this.endDateTime,
    this.endTimeStr,
    this.endDateStr,
    this.duration,
    this.dayOfWeek,
    this.taskDetails,
    this.additionalMessage,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.recurrenceRule,
    this.recurrenceStr,
  });

  factory SingleRoomModel.fromRawJson(String str) =>
      SingleRoomModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SingleRoomModel.fromJson(Map<String, dynamic> json) =>
      SingleRoomModel(
        id: json["_id"],
        user: json["user"],
        room: json["room"] == null ? null : Room.fromJson(json["room"]),
        assignedTo: json["assignedTo"] == null
            ? null
            : AssignedTo.fromJson(json["assignedTo"]),
        taskName: json["taskName"],
        recurrence: json["recurrence"],
        startDateStr: json["startDateStr"],
        startTimeStr: json["startTimeStr"],
        startDateTime: json["startDateTime"] == null
            ? null
            : DateTime.parse(json["startDateTime"]),
        endDateTime: json["endDateTime"] == null
            ? null
            : DateTime.parse(json["endDateTime"]),
        endTimeStr: json["endTimeStr"],
        endDateStr: json["endDateStr"],
        duration: json["duration"],
        dayOfWeek: json["dayOfWeek"],
        taskDetails: json["taskDetails"],
        additionalMessage: json["additionalMessage"],
        status: json["status"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        recurrenceRule: json["recurrenceRule"],
        recurrenceStr: json["recurrenceStr"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "user": user,
        "room": room?.toJson(),
        "assignedTo": assignedTo?.toJson(),
        "taskName": taskName,
        "recurrence": recurrence,
        "startDateStr": startDateStr,
        "startTimeStr": startTimeStr,
        "startDateTime": startDateTime?.toIso8601String(),
        "endDateTime": endDateTime?.toIso8601String(),
        "endTimeStr": endTimeStr,
        "endDateStr": endDateStr,
        "duration": duration,
        "dayOfWeek": dayOfWeek,
        "taskDetails": taskDetails,
        "additionalMessage": additionalMessage,
        "status": status,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "recurrenceRule": recurrenceRule,
        "recurrenceStr": recurrenceStr,
      };
}

class AssignedTo {
  String? id;
  String? firstName;
  String? lastName;
  String? email;
  String? profileImage;
  List<String>? workingDay;

  AssignedTo({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.profileImage,
    this.workingDay,
  });

  factory AssignedTo.fromRawJson(String str) =>
      AssignedTo.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AssignedTo.fromJson(Map<String, dynamic> json) => AssignedTo(
        id: json["_id"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        email: json["email"],
        profileImage: json["profile_image"],
        workingDay: json["workingDay"] == null
            ? []
            : List<String>.from(json["workingDay"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "firstName": firstName,
        "lastName": lastName,
        "email": email,
        "profile_image": profileImage,
        "workingDay": workingDay == null
            ? []
            : List<dynamic>.from(workingDay!.map((x) => x)),
      };
}

class Room {
  String? id;
  House? house;
  String? name;

  Room({
    this.id,
    this.house,
    this.name,
  });

  factory Room.fromRawJson(String str) => Room.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Room.fromJson(Map<String, dynamic> json) => Room(
        id: json["_id"],
        house: json["house"] == null ? null : House.fromJson(json["house"]),
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "house": house?.toJson(),
        "name": name,
      };
}

class House {
  String? id;
  String? name;

  House({
    this.id,
    this.name,
  });

  factory House.fromRawJson(String str) => House.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory House.fromJson(Map<String, dynamic> json) => House(
        id: json["_id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
      };
}
