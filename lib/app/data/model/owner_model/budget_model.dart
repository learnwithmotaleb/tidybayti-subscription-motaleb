import 'dart:convert';

class BudgetModel {
  final int? statusCode;
  final bool? success;
  final String? message;
  final BudgetData? data;

  BudgetModel({
    this.statusCode,
    this.success,
    this.message,
    this.data,
  });

  factory BudgetModel.fromRawJson(String str) => BudgetModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory BudgetModel.fromJson(Map<String, dynamic> json) => BudgetModel(
    statusCode: json["statusCode"],
    success: json["success"],
    message: json["message"],
    data: json["data"] == null ? null : BudgetData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "statusCode": statusCode,
    "success": success,
    "message": message,
    "data": data?.toJson(),
  };
}

class BudgetData {
  final Meta? meta;
  final List<Result>? result;

  BudgetData({
    this.meta,
    this.result,
  });

  factory BudgetData.fromRawJson(String str) => BudgetData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory BudgetData.fromJson(Map<String, dynamic> json) => BudgetData(
    meta: json["meta"] == null ? null : Meta.fromJson(json["meta"]),
    result: json["result"] == null ? [] : List<Result>.from(json["result"]!.map((x) => Result.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "meta": meta?.toJson(),
    "result": result == null ? [] : List<dynamic>.from(result!.map((x) => x.toJson())),
  };
}

class Meta {
  final int? page;
  final int? limit;
  final int? total;
  final int? totalPage;

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
  final String? id;
  final String? user;
  final String? category;
  final String? budgetImage;
  final String? budgetDateStr;
  final String? currency;
  final int? amount;
  final int? currentExpense;
  final List<dynamic>? expenses;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? budgetDateTime;
  final String? budgetMonth;
  final String? budgetYear;

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
