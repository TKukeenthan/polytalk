import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/usecases/get_subscription_status.dart';
import '../../domain/usecases/purchase_subscription.dart';
import '../../domain/usecases/restore_purchases.dart';
import 'subscription_event.dart';
import 'subscription_state.dart';

class SubscriptionBloc extends Bloc<SubscriptionEvent, SubscriptionState> {
  final GetSubscriptionStatus getSubscriptionStatus;
  final PurchaseSubscription purchaseSubscription;
  final RestorePurchases restorePurchases;

  SubscriptionBloc({
    required this.getSubscriptionStatus,
    required this.purchaseSubscription,
    required this.restorePurchases,
  }) : super(SubscriptionInitial()) {
    on<CheckSubscriptionStatusEvent>(_onCheckStatus);
    on<PurchasePackageEvent>(_onPurchase);
    on<RestorePurchasesEvent>(_onRestore);
  }

  Future<void> _onCheckStatus(
    CheckSubscriptionStatusEvent event,
    Emitter<SubscriptionState> emit,
  ) async {
    emit(SubscriptionLoading());
    final result = await getSubscriptionStatus(NoParams());
    result.fold(
      (failure) => emit(SubscriptionError(failure.toString())),
      (subscription) {
        if (subscription.isActive) {
          emit(SubscriptionActive(subscription));
        } else {
          emit(SubscriptionInactive());
        }
      },
    );
  }

  Future<void> _onPurchase(
    PurchasePackageEvent event,
    Emitter<SubscriptionState> emit,
  ) async {
    emit(SubscriptionLoading());
    final result = await purchaseSubscription(event.package.storeProduct.identifier);
    result.fold(
      (failure) => emit(SubscriptionError(failure.toString())),
      (subscription) {
         if (subscription.isActive) {
          emit(SubscriptionActive(subscription));
        } else {
          emit(SubscriptionInactive());
        }
      },
    );
  }

  Future<void> _onRestore(
    RestorePurchasesEvent event,
    Emitter<SubscriptionState> emit,
  ) async {
    emit(SubscriptionLoading());
    final result = await restorePurchases(NoParams());
    result.fold(
      (failure) => emit(SubscriptionError(failure.toString())),
      (subscription) {
         if (subscription.isActive) {
          emit(SubscriptionActive(subscription));
        } else {
          emit(SubscriptionInactive());
        }
      },
    );
  }
}