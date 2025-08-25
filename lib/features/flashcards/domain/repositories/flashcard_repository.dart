import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/flashcard.dart';

abstract class FlashcardRepository {
  Future<Either<Failure, List<Flashcard>>> getFlashcards(String language);
  Future<Either<Failure, Flashcard>> generateFlashcard(String text, String language);
  Future<Either<Failure, void>> practiceFlashcard(Flashcard flashcard);
}