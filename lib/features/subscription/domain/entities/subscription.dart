import 'package:equatable/equatable.dart';

class Subscription extends Equatable {
  final bool isActive;
  final String? productId;
  final String? expirationDate;
  final String? purchaseDate;
  final String planType;

  const Subscription({
    required this.isActive,
    this.productId,
    this.expirationDate,
    this.purchaseDate,
    required this.planType,
  });

  @override
  List<Object?> get props => [isActive, productId, expirationDate, purchaseDate, planType];
}