import '../../domain/entities/progress.dart';
import 'package:equatable/equatable.dart';

abstract class ProgressEvent extends Equatable {
  const ProgressEvent();

  @override
  List<Object?> get props => [];
}

class LoadProgress extends ProgressEvent {
  final String userId;
  const LoadProgress(this.userId);

  @override
  List<Object?> get props => [userId];
}

class UpdateConversationProgressEvent extends ProgressEvent {
  final String userId;
  final int conversationsToday;
  const UpdateConversationProgressEvent(this.userId, this.conversationsToday);

  @override
  List<Object?> get props => [userId, conversationsToday];
}

class UpdateFlashcardProgressEvent extends ProgressEvent {
  final String userId;
  final int flashcardsReviewed;
  const UpdateFlashcardProgressEvent(this.userId, this.flashcardsReviewed);

  @override
  List<Object?> get props => [userId, flashcardsReviewed];
}

class UpdateStreakProgressEvent extends ProgressEvent {
  final String userId;
  final int streak;
  const UpdateStreakProgressEvent(this.userId, this.streak);

  @override
  List<Object?> get props => [userId, streak];
}
