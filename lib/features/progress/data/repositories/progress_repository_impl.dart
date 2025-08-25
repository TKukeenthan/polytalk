import '../../domain/entities/progress.dart';
import '../../domain/repositories/progress_repository.dart';
import '../datasources/progress_remote_datasource.dart';

class ProgressRepositoryImpl implements ProgressRepository {
  final ProgressRemoteDatasource remoteDatasource;
  ProgressRepositoryImpl(this.remoteDatasource);

  @override
  Future<Progress> getProgress(String userId) {
    return remoteDatasource.getProgress(userId);
  }

  @override
  Future<void> updateConversationProgress(String userId, int conversationsToday) {
    return remoteDatasource.updateConversationProgress(userId, conversationsToday);
  }

  @override
  Future<void> updateFlashcardProgress(String userId, int flashcardsReviewed) {
    return remoteDatasource.updateFlashcardProgress(userId, flashcardsReviewed);
  }

  @override
  Future<void> updateStreakProgress(String userId, int streak) {
    return remoteDatasource.updateStreakProgress(userId, streak);
  }
}
