import '../repositories/progress_repository.dart';

class UpdateStreakProgress {
  final ProgressRepository repository;
  UpdateStreakProgress(this.repository);

  Future<void> call(String userId, int streak) {
    return repository.updateStreakProgress(userId, streak);
  }
}
