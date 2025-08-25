import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/subscription.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

abstract class SubscriptionRepository {
  Future<Either<Failure, Subscription>> getSubscriptionStatus();
  Future<Either<Failure, Subscription>> purchaseSubscription(String productId);
  Future<Either<Failure, Subscription>> restorePurchases();
  Future<Either<Failure, List<Package>>> getAvailablePackages();
}