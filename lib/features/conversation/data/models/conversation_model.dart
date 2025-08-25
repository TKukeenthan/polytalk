import '../../domain/entities/conversation.dart';
import 'message_model.dart';

class ConversationModel extends Conversation {
  const ConversationModel({
    required String id,
    required String userId,
    required String targetLanguage,
    required List<MessageModel> messages,
    required DateTime createdAt,
    required DateTime lastUpdatedAt,
  }) : super(
          id: id,
          userId: userId,
          targetLanguage: targetLanguage,
          messages: messages,
          createdAt: createdAt,
          lastUpdatedAt: lastUpdatedAt,
        );

  factory ConversationModel.fromJson(Map<String, dynamic> json) {
    return ConversationModel(
      id: json['id'],
      userId: json['userId'],
      targetLanguage: json['targetLanguage'],
      messages: (json['messages'] as List)
          .map((msg) => MessageModel.fromJson(msg))
          .toList(),
      createdAt: DateTime.parse(json['createdAt']),
      lastUpdatedAt: DateTime.parse(json['lastUpdatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'targetLanguage': targetLanguage,
      'messages': messages.map((msg) => (msg as MessageModel).toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'lastUpdatedAt': lastUpdatedAt.toIso8601String(),
    };
  }
}