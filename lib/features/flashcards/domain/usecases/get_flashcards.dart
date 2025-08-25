import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/flashcard.dart';
import '../repositories/flashcard_repository.dart';

class GetFlashcards implements UseCase<List<Flashcard>, String> {
  final FlashcardRepository repository;

  GetFlashcards(this.repository);

  @override
  Future<Either<Failure, List<Flashcard>>> call(String language) async {
    return await repository.getFlashcards(language);
  }
}