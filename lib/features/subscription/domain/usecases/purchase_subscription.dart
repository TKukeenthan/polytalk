import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/subscription.dart';
import '../repositories/subscription_repository.dart';

class PurchaseSubscription implements UseCase<Subscription, String> {
  final SubscriptionRepository repository;

  PurchaseSubscription(this.repository);

  @override
  Future<Either<Failure, Subscription>> call(String productId) async {
    return await repository.purchaseSubscription(productId);
  }
}