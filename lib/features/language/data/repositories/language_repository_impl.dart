import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/language.dart';
import '../../domain/repositories/language_repository.dart';
import '../datasources/language_local_datasource.dart';
import '../models/language_model.dart';

class LanguageRepositoryImpl implements LanguageRepository {
  final LanguageLocalDataSource localDataSource;

  LanguageRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, List<Language>>> getAvailableLanguages() async {
    try {
      final languages = await localDataSource.getAvailableLanguages();
      return Right(languages);
    } on CacheException {
      return Left(CacheFailure());
    }
  }
  
  @override
  Future<Either<Failure, void>> setTargetLanguage(Language language) async {
    try {
      final languageModel = LanguageModel(code: language.code, name: language.name);
      await localDataSource.setTargetLanguage(languageModel);
      return const Right(null);
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, Language>> getTargetLanguage() async {
    try {
      final language = await localDataSource.getTargetLanguage();
      return Right(language);
    } on CacheException {
      return Left(CacheFailure());
    }
  }
}