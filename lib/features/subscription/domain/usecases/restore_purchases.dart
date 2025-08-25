import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/subscription.dart';
import '../repositories/subscription_repository.dart';

class RestorePurchases implements UseCase<Subscription, NoParams> {
  final SubscriptionRepository repository;

  RestorePurchases(this.repository);

  @override
  Future<Either<Failure, Subscription>> call(NoParams params) async {
    return await repository.restorePurchases();
  }
}