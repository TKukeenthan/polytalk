import 'package:equatable/equatable.dart';
import 'message.dart';

class Conversation extends Equatable {
  final String id;
  final String userId;
  final String targetLanguage;
  final List<Message> messages;
  final DateTime createdAt;
  final DateTime lastUpdatedAt;

  const Conversation({
    required this.id,
    required this.userId,
    required this.targetLanguage,
    required this.messages,
    required this.createdAt,
    required this.lastUpdatedAt,
  });

  @override
  List<Object> get props => [id, userId, targetLanguage, messages, createdAt, lastUpdatedAt];
}