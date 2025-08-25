import '../../domain/entities/message.dart';
import 'grammar_correction_model.dart';

class MessageModel extends Message {
  const MessageModel({
    required String id,
    required String content,
    required bool isFromUser,
    required DateTime timestamp,
    List<GrammarCorrectionModel>? corrections,
    String? audioUrl,
  }) : super(
          id: id,
          content: content,
          isFromUser: isFromUser,
          timestamp: timestamp,
          corrections: corrections,
          audioUrl: audioUrl,
        );

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'],
      content: json['content'],
      isFromUser: json['isFromUser'],
      timestamp: DateTime.parse(json['timestamp']),
      corrections: json['corrections'] != null
          ? (json['corrections'] as List)
              .map((e) => GrammarCorrectionModel.fromJson(e))
              .toList()
          : null,
      audioUrl: json['audioUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'isFromUser': isFromUser,
      'timestamp': timestamp.toIso8601String(),
      'corrections': corrections?.map((e) => (e as GrammarCorrectionModel).toJson()).toList(),
      'audioUrl': audioUrl,
    };
  }

  factory MessageModel.fromEntity(Message message) {
    return MessageModel(
      id: message.id,
      content: message.content,
      isFromUser: message.isFromUser,
      timestamp: message.timestamp,
      corrections: message.corrections?.cast<GrammarCorrectionModel>(),
      audioUrl: message.audioUrl,
    );
  }
}