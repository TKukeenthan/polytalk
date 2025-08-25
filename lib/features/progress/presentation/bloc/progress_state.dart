import '../../domain/entities/progress.dart';
import 'package:equatable/equatable.dart';

abstract class ProgressState extends Equatable {
  const ProgressState();

  @override
  List<Object?> get props => [];
}

class ProgressInitial extends ProgressState {}

class ProgressLoading extends ProgressState {}

class ProgressLoaded extends ProgressState {
  final Progress progress;
  const ProgressLoaded(this.progress);

  @override
  List<Object?> get props => [progress];
}

class ProgressError extends ProgressState {
  final String message;
  const ProgressError(this.message);

  @override
  List<Object?> get props => [message];
}
