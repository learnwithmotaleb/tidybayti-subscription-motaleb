import 'dart:convert';

class GroceryTaskModel {
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
  String? groceryName;

  GroceryTaskModel({
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
    this.groceryName,
  });

  factory GroceryTaskModel.fromRawJson(String str) =>
      GroceryTaskModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GroceryTaskModel.fromJson(Map<String, dynamic> json) {
    try {
      return GroceryTaskModel(
        id: json["_id"],
        user: json["user"],
        assignedTo: json["assignedTo"] == null
            ? null
            : AssignedTo.fromJson(json["assignedTo"]),
        groceryList: _parseGroceryList(json["groceryList"]),
        recurrence: json["recurrence"],
        startDateStr: json["startDateStr"],
        startTimeStr: json["startTimeStr"],
        startDateTime: json["startDateTime"] == null
            ? null
            : DateTime.tryParse(json["startDateTime"]),
        endDateStr: json["endDateStr"],
        endTimeStr: json["endTimeStr"],
        endDateTime: json["endDateTime"] == null
            ? null
            : DateTime.tryParse(json["endDateTime"]),
        dayOfWeek: json["dayOfWeek"],
        additionalMessage: json["additionalMessage"],
        status: json["status"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.tryParse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.tryParse(json["updatedAt"]),
        groceryName: json["groceryName"],
      );
    } catch (e) {
      print('Error parsing GroceryTaskModel: $e');
      print('JSON data: $json');
      rethrow;
    }
  }

  // Helper method to safely parse groceryList
  static List<String>? _parseGroceryList(dynamic groceryListData) {
    if (groceryListData == null) return null;

    if (groceryListData is List) {
      return groceryListData.map((item) => item.toString()).toList();
    }

    // If it's not a list, return empty list
    return [];
  }

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
        "groceryName": groceryName,
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

  factory AssignedTo.fromJson(Map<String, dynamic> json) {
    try {
      return AssignedTo(
        id: json["_id"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        email: json["email"],
        profileImage: json["profile_image"],
        workingDay: _parseWorkingDay(json["workingDay"]),
      );
    } catch (e) {
      print('Error parsing AssignedTo: $e');
      print('JSON data: $json');
      rethrow;
    }
  }

  // Helper method to safely parse workingDay
  static List<String>? _parseWorkingDay(dynamic workingDayData) {
    if (workingDayData == null) return null;

    if (workingDayData is List) {
      return workingDayData.map((item) => item.toString()).toList();
    }

    return [];
  }

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
