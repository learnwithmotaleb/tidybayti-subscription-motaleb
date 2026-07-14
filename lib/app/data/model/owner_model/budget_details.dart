import 'dart:convert';

class BudgetDetails {
  int? statusCode;
  bool? success;
  String? message;
  BudgetDetailsData? data;

  BudgetDetails({
    this.statusCode,
    this.success,
    this.message,
    this.data,
  });

  factory BudgetDetails.fromRawJson(String str) => BudgetDetails.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory BudgetDetails.fromJson(Map<String, dynamic> json) => BudgetDetails(
    statusCode: json["statusCode"],
    success: json["success"],
    message: json["message"],
    data: json["data"] == null ? null : BudgetDetailsData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "statusCode": statusCode,
    "success": success,
    "message": message,
    "data": data?.toJson(),
  };
}

class BudgetDetailsData {
  String? id;
  String? user;
  String? category;
  String? budgetImage;
  String? budgetDateStr;
  String? currency;
  int? amount;
  int? currentExpense;
  List<Expense>? expenses;
  DateTime? createdAt;
  DateTime? updatedAt;
  DateTime? budgetDateTime;
  String? budgetMonth;
  String? budgetYear;
  int? v;

  BudgetDetailsData({
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
    this.v,
  });

  factory BudgetDetailsData.fromRawJson(String str) => BudgetDetailsData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory BudgetDetailsData.fromJson(Map<String, dynamic> json) => BudgetDetailsData(
    id: json["_id"],
    user: json["user"],
    category: json["category"],
    budgetImage: json["budgetImage"],
    budgetDateStr: json["budgetDateStr"],
    currency: json["currency"],
    amount: json["amount"],
    currentExpense: json["currentExpense"],
    expenses: json["expenses"] == null ? [] : List<Expense>.from(json["expenses"]!.map((x) => Expense.fromJson(x))),
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    budgetDateTime: json["budgetDateTime"] == null ? null : DateTime.parse(json["budgetDateTime"]),
    budgetMonth: json["budgetMonth"],
    budgetYear: json["budgetYear"],
    v: json["__v"],
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
    "expenses": expenses == null ? [] : List<dynamic>.from(expenses!.map((x) => x.toJson())),
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "budgetDateTime": budgetDateTime?.toIso8601String(),
    "budgetMonth": budgetMonth,
    "budgetYear": budgetYear,
    "__v": v,
  };
}

class Expense {
  String? id;
  String? user;
  String? budget;
  String? expenseDateStr;
  int? amount;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;

  Expense({
    this.id,
    this.user,
    this.budget,
    this.expenseDateStr,
    this.amount,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory Expense.fromRawJson(String str) => Expense.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Expense.fromJson(Map<String, dynamic> json) => Expense(
    id: json["_id"],
    user: json["user"],
    budget: json["budget"],
    expenseDateStr: json["expenseDateStr"],
    amount: json["amount"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "user": user,
    "budget": budget,
    "expenseDateStr": expenseDateStr,
    "amount": amount,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "__v": v,
  };
}
