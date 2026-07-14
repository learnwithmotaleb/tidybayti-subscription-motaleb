import 'dart:convert';

class BudgetCategory {
  int? statusCode;
  bool? success;
  String? message;
  List<CategoryList>? data;

  BudgetCategory({
    this.statusCode,
    this.success,
    this.message,
    this.data,
  });

  factory BudgetCategory.fromRawJson(String str) => BudgetCategory.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory BudgetCategory.fromJson(Map<String, dynamic> json) => BudgetCategory(
    statusCode: json["statusCode"],
    success: json["success"],
    message: json["message"],
    data: json["data"] == null ? [] : List<CategoryList>.from(json["data"]!.map((x) => CategoryList.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "statusCode": statusCode,
    "success": success,
    "message": message,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class CategoryList {
  String? name;
  String? image;

  CategoryList({
    this.name,
    this.image,
  });

  factory CategoryList.fromRawJson(String str) => CategoryList.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CategoryList.fromJson(Map<String, dynamic> json) => CategoryList(
    name: json["name"],
    image: json["image"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "image": image,
  };
}
