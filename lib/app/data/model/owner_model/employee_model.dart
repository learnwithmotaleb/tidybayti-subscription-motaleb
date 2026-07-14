import 'dart:convert';

class EmployeeModel {
  int? statusCode;
  bool? success;
  String? message;
  EmployeeData? data;

  EmployeeModel({
    this.statusCode,
    this.success,
    this.message,
    this.data,
  });

  factory EmployeeModel.fromRawJson(String str) => EmployeeModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory EmployeeModel.fromJson(Map<String, dynamic> json) => EmployeeModel(
    statusCode: json["statusCode"],
    success: json["success"],
    message: json["message"],
    data: json["data"] == null ? null : EmployeeData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "statusCode": statusCode,
    "success": success,
    "message": message,
    "data": data?.toJson(),
  };
}

class EmployeeData {
  Meta? meta;
  List<Result>? result;

  EmployeeData({
    this.meta,
    this.result,
  });

  factory EmployeeData.fromRawJson(String str) => EmployeeData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory EmployeeData.fromJson(Map<String, dynamic> json) => EmployeeData(
    meta: json["meta"] == null ? null : Meta.fromJson(json["meta"]),
    result: json["result"] == null ? [] : List<Result>.from(json["result"]!.map((x) => Result.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "meta": meta?.toJson(),
    "result": result == null ? [] : List<dynamic>.from(result!.map((x) => x.toJson())),
  };
}

class Meta {
  int? page;
  int? limit;
  int? total;
  int? totalPage;

  Meta({
    this.page,
    this.limit,
    this.total,
    this.totalPage,
  });

  factory Meta.fromRawJson(String str) => Meta.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
    page: json["page"],
    limit: json["limit"],
    total: json["total"],
    totalPage: json["totalPage"],
  );

  Map<String, dynamic> toJson() => {
    "page": page,
    "limit": limit,
    "total": total,
    "totalPage": totalPage,
  };
}

class Result {
  String? id;
  String? authId;
  String? firstName;
  String? lastName;
  String? email;
  String? profileImage;
  String? phoneNumber;
  String? employer;
  String? jobType;
  String? cprNumber;
  String? cprExpDate;
  String? passportNumber;
  String? passportExpDate;
  String? note;
  String? dutyTime;
  List<String>? workingDay;
  String? offDay;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? employeeId;
  String? address;
  String? designation;
  String? cpr;
  String? passport;
  String? drivingLicense;
  String? name;

  Result({
    this.id,
    this.authId,
    this.firstName,
    this.lastName,
    this.email,
    this.profileImage,
    this.phoneNumber,
    this.employer,
    this.jobType,
    this.cprNumber,
    this.cprExpDate,
    this.passportNumber,
    this.passportExpDate,
    this.note,
    this.dutyTime,
    this.workingDay,
    this.offDay,
    this.createdAt,
    this.updatedAt,
    this.employeeId,
    this.address,
    this.designation,
    this.cpr,
    this.passport,
    this.drivingLicense,
    this.name,
  });

  factory Result.fromRawJson(String str) => Result.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    id: json["_id"],
    authId: json["authId"],
    firstName: json["firstName"],
    lastName: json["lastName"],
    email: json["email"],
    profileImage: json["profile_image"],
    phoneNumber: json["phoneNumber"],
    employer: json["employer"],
    jobType: json["jobType"],
    cprNumber: json["CPRNumber"],
    cprExpDate: json["CPRExpDate"],
    passportNumber: json["passportNumber"],
    passportExpDate: json["passportExpDate"],
    note: json["note"],
    dutyTime: json["dutyTime"],
    workingDay: json["workingDay"] == null ? [] : List<String>.from(json["workingDay"]!.map((x) => x)),
    offDay: json["offDay"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    employeeId: json["employeeId"],
    address: json["address"],
    designation: json["designation"],
    cpr: json["CPR"],
    passport: json["passport"],
    drivingLicense: json["drivingLicense"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "authId": authId,
    "firstName": firstName,
    "lastName": lastName,
    "email": email,
    "profile_image": profileImage,
    "phoneNumber": phoneNumber,
    "employer": employer,
    "jobType": jobType,
    "CPRNumber": cprNumber,
    "CPRExpDate": cprExpDate,
    "passportNumber": passportNumber,
    "passportExpDate": passportExpDate,
    "note": note,
    "dutyTime": dutyTime,
    "workingDay": workingDay == null ? [] : List<dynamic>.from(workingDay!.map((x) => x)),
    "offDay": offDay,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "employeeId": employeeId,
    "address": address,
    "designation": designation,
    "CPR": cpr,
    "passport": passport,
    "drivingLicense": drivingLicense,
    "name": name,
  };
}
