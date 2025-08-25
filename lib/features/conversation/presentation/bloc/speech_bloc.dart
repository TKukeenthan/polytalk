import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/speech_to_text.dart';
import '../../domain/usecases/text_to_speech.dart';
import 'speech_event.dart';
import 'speech_state.dart';

class SpeechBloc extends Bloc<SpeechEvent, SpeechState> {
  final SpeechToTextUseCase speechToText;
  final TextToSpeechUseCase textToSpeech;
  
  SpeechBloc({
    required this.speechToText,
    required this.textToSpeech,
  }) : super(SpeechInitial()) {
    on<StartListeningEvent>(_onStartListening);
    on<StopListeningEvent>(_onStopListening);
    on<TextToSpeechEvent>(_onTextToSpeech);
  }

  Future<void> _onStartListening(
    StartListeningEvent event,
    Emitter<SpeechState> emit,
  ) async {
    emit(SpeechListening());
    final result = await speechToText(event.localeId);
    result.fold(
      (failure) => emit(SpeechError(failure.toString())),
      (text) => emit(SpeechRecognized(text)),
    );
  }
  
  Future<void> _onStopListening(
    StopListeningEvent event,
    Emitter<SpeechState> emit,
  ) async {
    // In a real app, you would interact with the SpeechDataSource to stop listening
    // For now, we assume the use case handles completion.
    emit(SpeechInitial());
  }
  
  Future<void> _onTextToSpeech(
    TextToSpeechEvent event,
    Emitter<SpeechState> emit,
  ) async {
    emit(SpeechPlaying());
    final result = await textToSpeech(TextToSpeechParams(
      text: event.text,
      language: event.language,
    ));
    result.fold(
      (failure) => emit(SpeechError(failure.toString())),
      (_) => emit(SpeechPlayed()),
    );
  }
}