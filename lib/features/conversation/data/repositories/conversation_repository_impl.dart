import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/conversation.dart';
import '../../domain/entities/message.dart';
import '../../domain/repositories/conversation_repository.dart';
import '../datasources/ai_remote_datasource.dart';
import '../datasources/conversation_local_datasource.dart';
import '../datasources/speech_datasource.dart';
import '../models/message_model.dart';

class ConversationRepositoryImpl implements ConversationRepository {
  final AIRemoteDataSource aiRemoteDataSource;
  final SpeechDataSource speechDataSource;
  final ConversationLocalDataSource localDataSource;

  ConversationRepositoryImpl({
    required this.aiRemoteDataSource,
    required this.speechDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, Message>> sendMessage(
    String conversationId,
    String content,
    String targetLanguage,
  ) async {
    try {
      // 1. Get grammar corrections for the user's message
      final corrections = await aiRemoteDataSource.getGrammarCorrections(content, targetLanguage);
      
      // 2. Create the user's message object
      final userMessage = MessageModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        content: content,
        isFromUser: true,
        timestamp: DateTime.now(),
        corrections: corrections,
      );
      
      // In a real app, you would save this message to the conversation history
      // For now, we just return the message
      return Right(userMessage);

    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, Message>> getAIResponse(
    String conversationId,
    String userMessage,
    String targetLanguage,
  ) async {
    try {
      // In a real app, you'd fetch the conversation history from the local data source
      final conversationHistory = <MessageModel>[]; 
      
      final aiMessage = await aiRemoteDataSource.getAIResponse(
        userMessage,
        targetLanguage,
        conversationHistory,
      );
      return Right(aiMessage);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, String>> speechToText(String audioPath) async {
    try {
      final text = await speechDataSource.speechToText(audioPath);
      return Right(text);
    } on SpeechException catch (e) {
      return Left(SpeechFailure(e.message));
    }
  }
  
  @override
  Future<Either<Failure, String>> textToSpeech(String text, String language) async {
    try {
      final audioUrl = await speechDataSource.textToSpeech(text, language);
      return Right(audioUrl);
    } on SpeechException catch(e) {
      return Left(SpeechFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<Conversation>>> getConversationHistory() async {
    // Implementation for fetching conversation history
    throw UnimplementedError();
  }
}