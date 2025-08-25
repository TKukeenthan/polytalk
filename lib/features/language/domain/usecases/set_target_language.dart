import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/language.dart';
import '../repositories/language_repository.dart';

class SetTargetLanguage implements UseCase<void, Language> {
  final LanguageRepository repository;

  SetTargetLanguage(this.repository);

  @override
  Future<Either<Failure, void>> call(Language params) async {
    return await repository.setTargetLanguage(params);
  }
}