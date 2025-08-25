import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  const Failure([List properties = const <dynamic>[]]);
}

// General failures
class ServerFailure extends Failure {
  final String message;
  const ServerFailure(this.message);
  
  @override
  List<Object> get props => [message];
}

class CacheFailure extends Failure {
  @override
  List<Object> get props => [];
}

class NetworkFailure extends Failure {
  @override
  List<Object> get props => [];
}

class SubscriptionFailure extends Failure {
  final String message;
  const SubscriptionFailure(this.message);
  
  @override
  List<Object> get props => [message];
}

class SpeechFailure extends Failure {
  final String message;
  const SpeechFailure(this.message);
  
  @override
  List<Object> get props => [message];
}