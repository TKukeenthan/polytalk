import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/conversation_repository.dart';

class SpeechToTextUseCase implements UseCase<String, String> {
  final ConversationRepository repository;

  SpeechToTextUseCase(this.repository);

  @override
  Future<Either<Failure, String>> call(String languageCode) async {
    return await repository.speechToText(languageCode);
  }
}