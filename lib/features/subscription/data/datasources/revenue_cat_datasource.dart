import 'package:purchases_flutter/purchases_flutter.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/utils/constants.dart';
import '../models/subscription_model.dart';

// UPDATE THIS ABSTRACT CLASS
abstract class RevenueCatDataSource {
  Future<SubscriptionModel> getSubscriptionStatus();
  Future<SubscriptionModel> purchaseSubscription(Package package); // Takes a Package
  Future<SubscriptionModel> restorePurchases();
  Future<List<Package>> getAvailablePackages(); // Returns a list of Packages
}

// The implementation below this should be the one from the previous step.
class RevenueCatDataSourceImpl implements RevenueCatDataSource {
  
  RevenueCatDataSourceImpl() {
    _initializePurchases();
  }

  Future<void> _initializePurchases() async {
    try {
      await Purchases.setLogLevel(LogLevel.info);
      
      PurchasesConfiguration configuration = PurchasesConfiguration(
        AppConstants.revenueCatApiKey,
      );
      
      await Purchases.configure(configuration);
    } catch (e) {
      throw SubscriptionException('Failed to initialize RevenueCat: $e');
    }
  }

  @override
  Future<SubscriptionModel> getSubscriptionStatus() async {
    try {
      final customerInfo = await Purchases.getCustomerInfo();
      
      return SubscriptionModel(
        isActive: customerInfo.entitlements.all['pro']?.isActive ?? false,
        productId: customerInfo.entitlements.all['pro']?.productIdentifier,
        expirationDate: customerInfo.entitlements.all['pro']?.expirationDate,
        purchaseDate: customerInfo.entitlements.all['pro']?.latestPurchaseDate,
        planType: _getPlanType(customerInfo),
      );
    } catch (e) {
      throw SubscriptionException('Failed to get subscription status: $e');
    }
  }

  @override
  Future<SubscriptionModel> purchaseSubscription(Package packageToPurchase) async {
    try {
      final purchaseResult = await Purchases.purchasePackage(packageToPurchase);
      final customerInfo = purchaseResult.customerInfo;
      
      return SubscriptionModel(
        isActive: customerInfo.entitlements.all['pro']?.isActive ?? false,
        productId: customerInfo.entitlements.all['pro']?.productIdentifier,
        expirationDate: customerInfo.entitlements.all['pro']?.expirationDate,
        purchaseDate: customerInfo.entitlements.all['pro']?.latestPurchaseDate,
        planType: _getPlanType(customerInfo),
      );
    } catch (e) {
      throw SubscriptionException('Failed to purchase subscription: $e');
    }
  }

  @override
  Future<SubscriptionModel> restorePurchases() async {
    try {
      final customerInfo = await Purchases.restorePurchases();
      
      return SubscriptionModel(
        isActive: customerInfo.entitlements.all['pro']?.isActive ?? false,
        productId: customerInfo.entitlements.all['pro']?.productIdentifier,
        expirationDate: customerInfo.entitlements.all['pro']?.expirationDate,
        purchaseDate: customerInfo.entitlements.all['pro']?.latestPurchaseDate,
        planType: _getPlanType(customerInfo),
      );
    } catch (e) {
      throw SubscriptionException('Failed to restore purchases: $e');
    }
  }

  @override
  Future<List<Package>> getAvailablePackages() async {
    try {
      final offerings = await Purchases.getOfferings();
      if (offerings.current != null) {
        return offerings.current!.availablePackages;
      }
      return [];
    } catch (e) {
      throw SubscriptionException('Failed to get available products: $e');
    }
  }

  String _getPlanType(CustomerInfo customerInfo) {
    if (customerInfo.entitlements.all['pro']?.isActive ?? false) {
      return 'pro';
    }
    return 'free';
  }
}