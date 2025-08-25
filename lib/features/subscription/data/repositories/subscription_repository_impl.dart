import 'package:dartz/dartz.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/subscription.dart';
import '../../domain/repositories/subscription_repository.dart';
import '../datasources/revenue_cat_datasource.dart';

class SubscriptionRepositoryImpl implements SubscriptionRepository {
  final RevenueCatDataSource dataSource;

  SubscriptionRepositoryImpl({required this.dataSource});

  @override
  Future<Either<Failure, Subscription>> getSubscriptionStatus() async {
    try {
      final status = await dataSource.getSubscriptionStatus();
      return Right(status);
    } on SubscriptionException catch (e) {
      return Left(SubscriptionFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, Subscription>> purchaseSubscription(String productId) async {
    try {
      // 1. Get all available packages from the data source
      final packages = await dataSource.getAvailablePackages();
      
      // 2. Find the specific package that matches the productId
      final packageToPurchase = packages.firstWhere(
        (pkg) => pkg.storeProduct.identifier == productId,
        orElse: () => throw const SubscriptionException('Product not found'),
      );

      // 3. Call the data source with the correct Package object
      final newStatus = await dataSource.purchaseSubscription(packageToPurchase);
      return Right(newStatus);
    } on SubscriptionException catch (e) {
      return Left(SubscriptionFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, Subscription>> restorePurchases() async {
    try {
      final restoredStatus = await dataSource.restorePurchases();
      return Right(restoredStatus);
    } on SubscriptionException catch (e) {
      return Left(SubscriptionFailure(e.message));
    }
  }
  
  // 4. Implement the new method name from the abstract class
  @override
  Future<Either<Failure, List<Package>>> getAvailablePackages() async {
    try {
      final packages = await dataSource.getAvailablePackages();
      return Right(packages);
    } on SubscriptionException catch(e) {
      return Left(SubscriptionFailure(e.message));
    }
  }
}