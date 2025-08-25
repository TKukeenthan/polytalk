import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/flashcard.dart';
import '../repositories/flashcard_repository.dart';

class GenerateFlashcard implements UseCase<Flashcard, GenerateFlashcardParams> {
  final FlashcardRepository repository;

  GenerateFlashcard(this.repository);

  @override
  Future<Either<Failure, Flashcard>> call(GenerateFlashcardParams params) async {
    return await repository.generateFlashcard(params.text, params.language);
  }
}

class GenerateFlashcardParams extends Equatable {
  final String text;
  final String language;

  const GenerateFlashcardParams({required this.text, required this.language});

  @override
  List<Object> get props => [text, language];
}