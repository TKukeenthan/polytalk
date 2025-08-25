import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/conversation_model.dart';

abstract class ConversationLocalDataSource {
  Future<void> cacheConversation(ConversationModel conversation);
  Future<ConversationModel> getConversation(String conversationId);
}

class ConversationLocalDataSourceImpl implements ConversationLocalDataSource {
  final SharedPreferences sharedPreferences;

  ConversationLocalDataSourceImpl({required this.sharedPreferences});
  
  @override
  Future<void> cacheConversation(ConversationModel conversation) {
    // This is a simplified implementation. A real app would use a database
    // like SQLite (via moor/drift or sqflite) or Hive for better performance.
    return sharedPreferences.setString(
      conversation.id,
      conversation.toJson().toString(),
    );
  }

  @override
  Future<ConversationModel> getConversation(String conversationId) {
    final jsonString = sharedPreferences.getString(conversationId);
    if (jsonString != null) {
      return Future.value(ConversationModel.fromJson(json.decode(jsonString)));
    } else {
      throw CacheException();
    }
  }
}