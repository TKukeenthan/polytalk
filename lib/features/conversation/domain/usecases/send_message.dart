import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/message.dart';
import '../repositories/conversation_repository.dart';

class SendMessage implements UseCase<Message, SendMessageParams> {
  final ConversationRepository repository;

  SendMessage(this.repository);

  @override
  Future<Either<Failure, Message>> call(SendMessageParams params) async {
    return await repository.sendMessage(
      params.conversationId,
      params.content,
      params.targetLanguage,
    );
  }
}

class SendMessageParams {
  final String conversationId;
  final String content;
  final String targetLanguage;

  SendMessageParams({
    required this.conversationId,
    required this.content,
    required this.targetLanguage,
  });
}