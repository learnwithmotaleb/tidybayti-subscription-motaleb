import 'dart:convert';

class GroceryModel {
  String? id;
  String? user;
  AssignedTo? assignedTo;
  List<String>? groceryList;
  String? recurrence;
  String? startDateStr;
  String? startTimeStr;
  DateTime? startDateTime;
  String? endDateStr;
  String? endTimeStr;
  DateTime? endDateTime;
  String? dayOfWeek;
  String? additionalMessage;
  String? status;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;

  GroceryModel({
    this.id,
    this.user,
    this.assignedTo,
    this.groceryList,
    this.recurrence,
    this.startDateStr,
    this.startTimeStr,
    this.startDateTime,
    this.endDateStr,
    this.endTimeStr,
    this.endDateTime,
    this.dayOfWeek,
    this.additionalMessage,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory GroceryModel.fromRawJson(String str) =>
      GroceryModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GroceryModel.fromJson(Map<String, dynamic> json) => GroceryModel(
        id: json["_id"],
        user: json["user"],
        assignedTo: json["assignedTo"] == null
            ? null
            : AssignedTo.fromJson(json["assignedTo"]),
        groceryList: json["groceryList"] == null
            ? []
            : List<String>.from(json["groceryList"]!.map((x) => x)),
        recurrence: json["recurrence"],
        startDateStr: json["startDateStr"],
        startTimeStr: json["startTimeStr"],
        startDateTime: json["startDateTime"] == null
            ? null
            : DateTime.parse(json["startDateTime"]),
        endDateStr: json["endDateStr"],
        endTimeStr: json["endTimeStr"],
        endDateTime: json["endDateTime"] == null
            ? null
            : DateTime.parse(json["endDateTime"]),
        dayOfWeek: json["dayOfWeek"],
        additionalMessage: json["additionalMessage"],
        status: json["status"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "user": user,
        "assignedTo": assignedTo?.toJson(),
        "groceryList": groceryList == null
            ? []
            : List<dynamic>.from(groceryList!.map((x) => x)),
        "recurrence": recurrence,
        "startDateStr": startDateStr,
        "startTimeStr": startTimeStr,
        "startDateTime": startDateTime?.toIso8601String(),
        "endDateStr": endDateStr,
        "endTimeStr": endTimeStr,
        "endDateTime": endDateTime?.toIso8601String(),
        "dayOfWeek": dayOfWeek,
        "additionalMessage": additionalMessage,
        "status": status,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "__v": v,
      };
}

class AssignedTo {
  String? id;
  String? firstName;
  String? lastName;
  String? email;
  String? profileImage;

  AssignedTo({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.profileImage,
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
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "firstName": firstName,
        "lastName": lastName,
        "email": email,
        "profile_image": profileImage,
      };
}
