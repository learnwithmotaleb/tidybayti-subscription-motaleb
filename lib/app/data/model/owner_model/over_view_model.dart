import 'dart:convert';

class OverviewModel {
  int? statusCode;
  bool? success;
  String? message;
  OverviewData? data;

  OverviewModel({
    this.statusCode,
    this.success,
    this.message,
    this.data,
  });

  factory OverviewModel.fromRawJson(String str) => OverviewModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory OverviewModel.fromJson(Map<String, dynamic> json) => OverviewModel(
    statusCode: json["statusCode"],
    success: json["success"],
    message: json["message"],
    data: json["data"] == null ? null : OverviewData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "statusCode": statusCode,
    "success": success,
    "message": message,
    "data": data?.toJson(),
  };
}

class OverviewData {
  Meta? meta;
  List<Result>? result;

  OverviewData({
    this.meta,
    this.result,
  });

  factory OverviewData.fromRawJson(String str) => OverviewData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory OverviewData.fromJson(Map<String, dynamic> json) => OverviewData(
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
  String? user;
  String? category;
  String? budgetImage;
  String? budgetDateStr;
  String? currency;
  int? amount;
  int? currentExpense;
  List<dynamic>? expenses;
  DateTime? createdAt;
  DateTime? updatedAt;
  DateTime? budgetDateTime;
  String? budgetMonth;
  String? budgetYear;

  Result({
    this.id,
    this.user,
    this.category,
    this.budgetImage,
    this.budgetDateStr,
    this.currency,
    this.amount,
    this.currentExpense,
    this.expenses,
    this.createdAt,
    this.updatedAt,
    this.budgetDateTime,
    this.budgetMonth,
    this.budgetYear,
  });

  factory Result.fromRawJson(String str) => Result.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    id: json["_id"],
    user: json["user"],
    category: json["category"],
    budgetImage: json["budgetImage"],
    budgetDateStr: json["budgetDateStr"],
    currency: json["currency"],
    amount: json["amount"],
    currentExpense: json["currentExpense"],
    expenses: json["expenses"] == null ? [] : List<dynamic>.from(json["expenses"]!.map((x) => x)),
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    budgetDateTime: json["budgetDateTime"] == null ? null : DateTime.parse(json["budgetDateTime"]),
    budgetMonth: json["budgetMonth"],
    budgetYear: json["budgetYear"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "user": user,
    "category": category,
    "budgetImage": budgetImage,
    "budgetDateStr": budgetDateStr,
    "currency": currency,
    "amount": amount,
    "currentExpense": currentExpense,
    "expenses": expenses == null ? [] : List<dynamic>.from(expenses!.map((x) => x)),
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "budgetDateTime": budgetDateTime?.toIso8601String(),
    "budgetMonth": budgetMonth,
    "budgetYear": budgetYear,
  };
}
