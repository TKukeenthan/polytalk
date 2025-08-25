import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/flashcard.dart';
import '../repositories/flashcard_repository.dart';

class PracticeFlashcard implements UseCase<void, Flashcard> {
  final FlashcardRepository repository;

  PracticeFlashcard(this.repository);

  @override
  Future<Either<Failure, void>> call(Flashcard flashcard) async {
    return await repository.practiceFlashcard(flashcard);
  }
}