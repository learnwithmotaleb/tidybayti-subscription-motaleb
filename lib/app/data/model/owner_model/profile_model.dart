import 'dart:convert';

class ProfileModel {
  final int? statusCode;
  final bool? success;
  final String? message;
  final ProfileData? data;

  ProfileModel({this.statusCode, this.success, this.message, this.data});

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      statusCode: json["statusCode"],
      success: json["success"],
      message: json["message"],
      data: json["data"] != null ? ProfileData.fromJson(json["data"]) : null,
    );
  }

  Map<String, dynamic> toJson() => {
        "statusCode": statusCode,
        "success": success,
        "message": message,
        "data": data?.toJson(),
      };

  static ProfileModel fromRawJson(String str) =>
      ProfileModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());
}

class ProfileData {
  final String? id;
  final AuthId? authId;
  final String? firstName;
  final String? lastName;
  final String? email;
  final List<dynamic>? workingDay;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? address;
  final String? phoneNumber;
  final String? cprNumber;
  final String? jobType;
  final String? dutyTime;
  final String? breakTimeStart;
  final String? breakTimeEnd;
  final String? passportNumber;
  final String? profileImage;

  ProfileData(
      {this.id,
      this.authId,
      this.firstName,
      this.lastName,
      this.breakTimeStart,
      this.breakTimeEnd,
      this.email,
      this.workingDay,
      this.createdAt,
      this.updatedAt,
      this.address,
      this.phoneNumber,
      this.profileImage,
      this.cprNumber,
      this.passportNumber,
      this.jobType,
      this.dutyTime});

  factory ProfileData.fromJson(Map<String, dynamic> json) => ProfileData(
        id: json["_id"],
        authId: json["authId"] != null ? AuthId.fromJson(json["authId"]) : null,
        firstName: json["firstName"],
        cprNumber: json["CPRNumber"],
        passportNumber: json["passportNumber"],
        jobType: json["jobType"],
        dutyTime: json["dutyTime"],
        breakTimeStart: json["breakTimeStart"],
        breakTimeEnd: json["breakTimeEnd"],
        lastName: json["lastName"],
        email: json["email"],
        workingDay: json["workingDay"] != null
            ? List<dynamic>.from(json["workingDay"])
            : [],
        createdAt: json["createdAt"] != null
            ? DateTime.parse(json["createdAt"])
            : null,
        updatedAt: json["updatedAt"] != null
            ? DateTime.parse(json["updatedAt"])
            : null,
        address: json["address"],
        phoneNumber: json["phoneNumber"],
        profileImage: json["profile_image"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "authId": authId?.toJson(),
        "firstName": firstName,
        "lastName": lastName,
        "email": email,
        "CPRNumber": cprNumber,
        "dutyTime": dutyTime,
        "breakTimeStart": breakTimeStart,
        "passportNumber": passportNumber,
        "jobType": jobType,
        "workingDay": workingDay ?? [],
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "address": address,
        "phoneNumber": phoneNumber,
        "profile_image": profileImage,
      };
}

class AuthId {
  final String? id;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? role;
  final bool? isBlocked;
  final bool? isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  AuthId({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.role,
    this.isBlocked,
    this.isActive,
    this.createdAt,
    this.updatedAt,
  });

  factory AuthId.fromJson(Map<String, dynamic> json) => AuthId(
        id: json["_id"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        email: json["email"],
        role: json["role"],
        isBlocked: json["isBlocked"],
        isActive: json["isActive"],
        createdAt: json["createdAt"] != null
            ? DateTime.parse(json["createdAt"])
            : null,
        updatedAt: json["updatedAt"] != null
            ? DateTime.parse(json["updatedAt"])
            : null,
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "firstName": firstName,
        "lastName": lastName,
        "email": email,
        "role": role,
        "isBlocked": isBlocked,
        "isActive": isActive,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
      };
}
