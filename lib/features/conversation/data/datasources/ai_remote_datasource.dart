import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/errors/exceptions.dart';
import '../../../../core/utils/constants.dart';
import '../models/message_model.dart';
import '../models/grammar_correction_model.dart';

abstract class AIRemoteDataSource {
  Future<MessageModel> getAIResponse(
    String userMessage,
    String targetLanguage,
    List<MessageModel> conversationHistory,
  );
  
  Future<List<GrammarCorrectionModel>> getGrammarCorrections(
    String text,
    String targetLanguage,
  );
}

class AIRemoteDataSourceImpl implements AIRemoteDataSource {
  final http.Client client;
  final String apiKey;

  AIRemoteDataSourceImpl({
    required this.client,
    required this.apiKey,
  });

  @override
  Future<MessageModel> getAIResponse(
    String userMessage,
    String targetLanguage,
    List<MessageModel> conversationHistory,
  ) async {
    try {
      final messages = _buildConversationHistory(
        userMessage,
        targetLanguage,
        conversationHistory,
      );

      final response = await client.post(
        Uri.parse('${AppConstants.openAIBaseUrl}chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: json.encode({
          
          'model': 'gpt-3.5-turbo',
          'messages': messages,
          // 'max_tokens': 150,
          // 'temperature': 0.7,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final aiMessage = data['choices'][0]['message']['content'];
        
        return MessageModel(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          content: aiMessage,
          isFromUser: false,
          timestamp: DateTime.now(),
        );
      } else {
        throw ServerException('Failed to get AI response');
      }
    } catch (e) {
      throw ServerException('Failed to get AI response: $e');
    }
  }

  @override
  Future<List<GrammarCorrectionModel>> getGrammarCorrections(
    String text,
    String targetLanguage,
  ) async {
    try {
      final prompt = '''
      Please analyze the following text in $targetLanguage for grammar errors.
      Return a JSON array of corrections with this format:
      [
        {
          "originalText": "original text",
          "correctedText": "corrected text",
          "explanation": "explanation of the error",
          "errorType": "grammar/spelling/syntax",
          "startIndex": 0,
          "endIndex": 10
        }
      ]
      
      Text to analyze: "$text"
      ''';

      final response = await client.post(
        Uri.parse('${AppConstants.openAIBaseUrl}chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: json.encode({
          'model': 'gpt-3.5-turbo',
          'messages': [
            {'role': 'user', 'content': prompt}
          ],
          'max_tokens': 300,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final correctionsJson = data['choices'][0]['message']['content'];
        
        try {
          final correctionsList = json.decode(correctionsJson) as List;
          return correctionsList
              .map((json) => GrammarCorrectionModel.fromJson(json))
              .toList();
        } catch (e) {
          // If JSON parsing fails, return empty list
          return [];
        }
      } else {
        throw ServerException('Failed to get grammar corrections ${response.body}');
      }
    }on ServerException catch (e) {
      print(e.message);
      throw ServerException('Failed to get grammar corrections: ${e.message}');
    }
  }

  List<Map<String, String>> _buildConversationHistory(
    String userMessage,
    String targetLanguage,
    List<MessageModel> history,
  ) {
    final messages = <Map<String, String>>[
      {
        'role': 'system',
        'content': '''
        You are a helpful language learning assistant. The user is learning $targetLanguage.
        Have a natural conversation with them, and provide gentle corrections when they make mistakes.
        Keep responses conversational and encouraging. Respond in $targetLanguage.
        '''
      }
    ];

    // Add conversation history
    for (final message in history.take(10)) { // Limit to last 10 messages
      messages.add({
        'role': message.isFromUser ? 'user' : 'assistant',
        'content': message.content,
      });
    }

    // Add current user message
    messages.add({
      'role': 'user',
      'content': userMessage,
    });

    return messages;
  }
}