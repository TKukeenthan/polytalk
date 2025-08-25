import 'package:equatable/equatable.dart';

abstract class SpeechEvent extends Equatable {
  const SpeechEvent();

  @override
  List<Object> get props => [];
}

class StartListeningEvent extends SpeechEvent {
  final String localeId;

  const StartListeningEvent(this.localeId);

  @override
  List<Object> get props => [localeId];
}

class StopListeningEvent extends SpeechEvent {
  const StopListeningEvent();
}

class TextToSpeechEvent extends SpeechEvent {
  final String text;
  final String language;

  const TextToSpeechEvent({required this.text, required this.language});
  
  @override
  List<Object> get props => [text, language];
}