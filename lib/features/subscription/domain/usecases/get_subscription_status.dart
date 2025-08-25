import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/subscription.dart';
import '../repositories/subscription_repository.dart';

class GetSubscriptionStatus implements UseCase<Subscription, NoParams> {
  final SubscriptionRepository repository;

  GetSubscriptionStatus(this.repository);

  @override
  Future<Either<Failure, Subscription>> call(NoParams params) async {
    return await repository.getSubscriptionStatus();
  }
}