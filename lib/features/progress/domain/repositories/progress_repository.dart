import '../entities/progress.dart';

abstract class ProgressRepository {
  Future<Progress> getProgress(String userId);
  Future<void> updateConversationProgress(String userId, int conversationsToday);
  Future<void> updateFlashcardProgress(String userId, int flashcardsReviewed);
  Future<void> updateStreakProgress(String userId, int streak);
}
