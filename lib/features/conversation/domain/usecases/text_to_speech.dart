import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/conversation_repository.dart';

class TextToSpeechUseCase implements UseCase<String, TextToSpeechParams> {
  final ConversationRepository repository;

  TextToSpeechUseCase(this.repository);

  @override
  Future<Either<Failure, String>> call(TextToSpeechParams params) async {
    return await repository.textToSpeech(params.text, params.language);
  }
}

class TextToSpeechParams extends Equatable {
  final String text;
  final String language;

  const TextToSpeechParams({required this.text, required this.language});

  @override
  List<Object> get props => [text, language];
}