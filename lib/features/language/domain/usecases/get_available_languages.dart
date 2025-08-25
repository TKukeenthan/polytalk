import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/language.dart';
import '../repositories/language_repository.dart';

class GetAvailableLanguages implements UseCase<List<Language>, NoParams> {
  final LanguageRepository repository;

  GetAvailableLanguages(this.repository);

  @override
  Future<Either<Failure, List<Language>>> call(NoParams params) async {
    return await repository.getAvailableLanguages();
  }
}