import 'package:equatable/equatable.dart';

abstract class ConversationEvent extends Equatable {
  const ConversationEvent();

  @override
  List<Object> get props => [];
}

class SendMessageEvent extends ConversationEvent {
  final String conversationId;
  final String content;
  final String targetLanguage;

  const SendMessageEvent({
    required this.conversationId,
    required this.content,
    required this.targetLanguage,
  });

  @override
  List<Object> get props => [conversationId, content, targetLanguage];
}

class GetAIResponseEvent extends ConversationEvent {
  final String conversationId;
  final String userMessage;
  final String targetLanguage;

  const GetAIResponseEvent({
    required this.conversationId,
    required this.userMessage,
    required this.targetLanguage,
  });

  @override
  List<Object> get props => [conversationId, userMessage, targetLanguage];
}

class LoadConversationEvent extends ConversationEvent {
  final String conversationId;

  const LoadConversationEvent(this.conversationId);

  @override
  List<Object> get props => [conversationId];
}