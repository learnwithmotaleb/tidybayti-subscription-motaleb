import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:tidybayte/app/data/subscription/subscription_service.dart';

class IosSubscriptionService extends SubscriptionService {
  static const String yearlyProductId = 'premium_yearly';
  static const String monthlyProductId = 'premium_monthly';

  IosSubscriptionService({
    super.onPurchaseUpdated,
    super.onError,
  });

  Future<void> restorePurchases() async {
    await InAppPurchase.instance.restorePurchases();
  }
}
