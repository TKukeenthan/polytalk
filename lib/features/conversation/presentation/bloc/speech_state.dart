import 'package:equatable/equatable.dart';

abstract class SpeechState extends Equatable {
  const SpeechState();

  @override
  List<Object> get props => [];
}

class SpeechInitial extends SpeechState {}

class SpeechListening extends SpeechState {}

class SpeechRecognized extends SpeechState {
  final String text;

  const SpeechRecognized(this.text);

  @override
  List<Object> get props => [text];
}

class SpeechError extends SpeechState {
  final String message;

  const SpeechError(this.message);

  @override
  List<Object> get props => [message];
}

class SpeechPlaying extends SpeechState {}

class SpeechPlayed extends SpeechState {}