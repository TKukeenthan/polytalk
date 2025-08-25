import 'package:equatable/equatable.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

abstract class SubscriptionEvent extends Equatable {
  const SubscriptionEvent();

  @override
  List<Object> get props => [];
}

class CheckSubscriptionStatusEvent extends SubscriptionEvent {
  const CheckSubscriptionStatusEvent();
}

class PurchasePackageEvent extends SubscriptionEvent {
  final Package package;
  const PurchasePackageEvent(this.package);
  
  @override
  List<Object> get props => [package];
}

class RestorePurchasesEvent extends SubscriptionEvent {
  const RestorePurchasesEvent();
}

class LoadProductsEvent extends SubscriptionEvent {
  const LoadProductsEvent();
}