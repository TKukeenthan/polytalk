import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/conversation.dart';
import '../entities/message.dart';

abstract class ConversationRepository {
  Future<Either<Failure, Message>> sendMessage(
    String conversationId,
    String content,
    String targetLanguage,
  );
  
  Future<Either<Failure, Message>> getAIResponse(
    String conversationId,
    String userMessage,
    String targetLanguage,
  );
  
  Future<Either<Failure, List<Conversation>>> getConversationHistory();
  
  Future<Either<Failure, String>> speechToText(String audioPath);
  
  Future<Either<Failure, String>> textToSpeech(String text, String language);
}