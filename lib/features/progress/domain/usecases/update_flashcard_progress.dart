import '../repositories/progress_repository.dart';

class UpdateFlashcardProgress {
  final ProgressRepository repository;
  UpdateFlashcardProgress(this.repository);

  Future<void> call(String userId, int flashcardsReviewed) {
    return repository.updateFlashcardProgress(userId, flashcardsReviewed);
  }
}
