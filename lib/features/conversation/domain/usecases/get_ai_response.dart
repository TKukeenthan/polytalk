import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/message.dart';
import '../repositories/conversation_repository.dart';

class GetAIResponse implements UseCase<Message, AIResponseParams> {
  final ConversationRepository repository;

  GetAIResponse(this.repository);

  @override
  Future<Either<Failure, Message>> call(AIResponseParams params) async {
    return await repository.getAIResponse(
      params.conversationId,
      params.userMessage,
      params.targetLanguage,
    );
  }
}

class AIResponseParams extends Equatable {
  final String conversationId;
  final String userMessage;
  final String targetLanguage;

  const AIResponseParams({
    required this.conversationId,
    required this.userMessage,
    required this.targetLanguage,
  });

  @override
  List<Object> get props => [conversationId, userMessage, targetLanguage];
}