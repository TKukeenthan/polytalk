import 'package:equatable/equatable.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import '../../domain/entities/subscription.dart';

abstract class SubscriptionState extends Equatable {
  const SubscriptionState();

  @override
  List<Object> get props => [];
}

class SubscriptionInitial extends SubscriptionState {}

class SubscriptionLoading extends SubscriptionState {}

class SubscriptionActive extends SubscriptionState {
  final Subscription subscription;
  const SubscriptionActive(this.subscription);
}

class SubscriptionInactive extends SubscriptionState {}

class SubscriptionError extends SubscriptionState {
  final String message;
  const SubscriptionError(this.message);
}

class ProductsLoaded extends SubscriptionState {
  final List<StoreProduct> products;
  const ProductsLoaded(this.products);
}