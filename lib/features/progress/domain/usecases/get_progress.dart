import '../entities/progress.dart';
import '../repositories/progress_repository.dart';

class GetProgress {
  final ProgressRepository repository;
  GetProgress(this.repository);

  Future<Progress> call(String userId) {
    return repository.getProgress(userId);
  }
}
