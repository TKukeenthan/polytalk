import '../repositories/progress_repository.dart';

class UpdateConversationProgress {
  final ProgressRepository repository;
  UpdateConversationProgress(this.repository);

  Future<void> call(String userId, int conversationsToday) {
    return repository.updateConversationProgress(userId, conversationsToday);
  }
}
