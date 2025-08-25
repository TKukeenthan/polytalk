import 'package:equatable/equatable.dart';
import 'grammar_correction.dart';

class Message extends Equatable {
  final String id;
  final String content;
  final bool isFromUser;
  final DateTime timestamp;
  final List<GrammarCorrection>? corrections;
  final String? audioUrl;

  const Message({
    required this.id,
    required this.content,
    required this.isFromUser,
    required this.timestamp,
    this.corrections,
    this.audioUrl,
  });

  @override
  List<Object?> get props => [
    id,
    content,
    isFromUser,
    timestamp,
    corrections,
    audioUrl,
  ];
}