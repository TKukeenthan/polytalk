import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/message.dart';
import '../../domain/usecases/send_message.dart';
import '../../domain/usecases/get_ai_response.dart';
import 'conversation_event.dart';
import 'conversation_state.dart';

class ConversationBloc extends Bloc<ConversationEvent, ConversationState> {
  final SendMessage sendMessage;
  final GetAIResponse getAIResponse;

  ConversationBloc({
    required this.sendMessage,
    required this.getAIResponse,
  }) : super(ConversationInitial()) {
    on<SendMessageEvent>(_onSendMessage);
    on<LoadConversationEvent>(_onLoadConversation);
    on<GetAIResponseEvent>(_onGetAIResponse); // Added handler for GetAIResponseEvent
  }

  Future<void> _onSendMessage(
    SendMessageEvent event,
    Emitter<ConversationState> emit,
  ) async {
    // Get current messages
    final currentState = state;
    List<Message> currentMessages = [];
    if (currentState is ConversationLoaded) {
      currentMessages = List.from(currentState.messages);
    }
    final result = await sendMessage(SendMessageParams(
      conversationId: event.conversationId,
      content: event.content,
      targetLanguage: event.targetLanguage,
    ));
    result.fold(
      (failure) => emit(ConversationError(failure.toString())),
      (message) {
        // Add user's message to the history and show loading
        emit(ConversationLoaded([...currentMessages, message], isLoading: true));
        add(GetAIResponseEvent(
          conversationId: event.conversationId,
          userMessage: event.content,
          targetLanguage: event.targetLanguage,
        ));
      },
    );
  }

  Future<void> _onLoadConversation(
    LoadConversationEvent event,
    Emitter<ConversationState> emit,
  ) async {
    emit(ConversationLoading());
    // Implementation for loading conversation history
  }

  Future<void> _onGetAIResponse(
    GetAIResponseEvent event,
    Emitter<ConversationState> emit,
  ) async {
    // Get current messages
    final currentState = state;
    List<Message> currentMessages = [];
    if (currentState is ConversationLoaded) {
      currentMessages = List.from(currentState.messages);
    }
    final result = await getAIResponse(AIResponseParams(
      conversationId: event.conversationId,
      userMessage: event.userMessage,
      targetLanguage: event.targetLanguage,
    ));
    result.fold(
      (failure) => emit(ConversationError(failure.toString())),
      (message) {
        // Add AI response to messages
        emit(ConversationLoaded([...currentMessages, message], isLoading: false));
      },
    );
  }
}