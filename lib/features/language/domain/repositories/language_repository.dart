import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/language.dart';

abstract class LanguageRepository {
  Future<Either<Failure, List<Language>>> getAvailableLanguages();
  Future<Either<Failure, void>> setTargetLanguage(Language language);
  Future<Either<Failure, Language>> getTargetLanguage();
}