import 'package:equatable/equatable.dart';
import '../../domain/entities/message.dart';

abstract class ConversationState extends Equatable {
  const ConversationState();

  @override
  List<Object> get props => [];
}

class ConversationInitial extends ConversationState {}

class ConversationLoading extends ConversationState {}

class ConversationLoaded extends ConversationState {
  final List<Message> messages;
  final bool isLoading;

  const ConversationLoaded(this.messages, {this.isLoading = false});

  @override
  List<Object> get props => [messages, isLoading];
}

class ConversationError extends ConversationState {
  final String message;

  const ConversationError(this.message);

  @override
  List<Object> get props => [message];
}