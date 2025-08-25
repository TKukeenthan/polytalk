import '../../domain/entities/subscription.dart';

class SubscriptionModel extends Subscription {
  const SubscriptionModel({
    required bool isActive,
    String? productId,
    String? expirationDate,
    String? purchaseDate,
    required String planType,
  }) : super(
          isActive: isActive,
          productId: productId,
          expirationDate: expirationDate,
          purchaseDate: purchaseDate,
          planType: planType,
        );
}