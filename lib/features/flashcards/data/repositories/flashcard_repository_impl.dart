
import 'package:dartz/dartz.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/errors/exceptions.dart';
import '../../domain/entities/flashcard.dart';
import '../../domain/repositories/flashcard_repository.dart';
import '../datasources/flashcard_local_datasource.dart';
import '../datasources/flashcard_remote_datasource.dart';
import '../models/flashcard_model.dart';

class FlashcardRepositoryImpl implements FlashcardRepository {
  final FlashcardLocalDataSource localDataSource;
  final FlashcardRemoteDataSource remoteDataSource;
  
  FlashcardRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, List<Flashcard>>> getFlashcards(String language) async {
    try {
      final localFlashcards = await localDataSource.getFlashcards(language);
      return Right(localFlashcards);
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, Flashcard>> generateFlashcard(String text, String language) async {
    try {
      // In a real app, you might use another AI call to get a translation or definition.
      // For this scaffold, we'll create a simple flashcard.
      final newFlashcard = FlashcardModel(
        id: const Uuid().v4(),
        frontText: text,
        backText: 'Generated translation for "$text"', // Placeholder
        language: language,
        difficulty: 'medium',
        createdAt: DateTime.now(),
      );
      
      await localDataSource.saveFlashcard(newFlashcard);
      return Right(newFlashcard);
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, void>> practiceFlashcard(Flashcard flashcard) async {
    try {
      final flashcardModel = FlashcardModel(
        id: flashcard.id,
        frontText: flashcard.frontText,
        backText: flashcard.backText,
        language: flashcard.language,
        difficulty: flashcard.difficulty,
        createdAt: flashcard.createdAt,
        // Update review stats here based on a spaced repetition algorithm
        lastReviewed: DateTime.now(),
        reviewCount: flashcard.reviewCount + 1,
      );
      await localDataSource.saveFlashcard(flashcardModel);
      return const Right(null);
    } on CacheException {
      return Left(CacheFailure());
    }
  }
}