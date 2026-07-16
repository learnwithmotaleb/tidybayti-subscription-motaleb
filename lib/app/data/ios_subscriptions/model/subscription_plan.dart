import 'package:in_app_purchase/in_app_purchase.dart';

class SubscriptionPlan {
  final ProductDetails product;
  final bool hasFreeTrial;

  const SubscriptionPlan({
    required this.product,
    required this.hasFreeTrial,
  });

  String get id => product.id;
  String get title => product.title;
  String get description => product.description;
  String get localizedPrice => product.price;
  String get currencyCode => product.currencyCode;

  bool get isMonthly => id == 'premium_monthly';
  bool get isYearly => id == 'premium_yearly';
}