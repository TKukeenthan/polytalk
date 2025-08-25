import 'package:equatable/equatable.dart';

class GrammarCorrection extends Equatable {
  final String originalText;
  final String correctedText;
  final String explanation;
  final String errorType;
  final int startIndex;
  final int endIndex;

  const GrammarCorrection({
    required this.originalText,
    required this.correctedText,
    required this.explanation,
    required this.errorType,
    required this.startIndex,
    required this.endIndex,
  });

  @override
  List<Object> get props => [
    originalText,
    correctedText,
    explanation,
    errorType,
    startIndex,
    endIndex,
  ];
}