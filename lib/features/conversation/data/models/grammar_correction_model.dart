import '../../domain/entities/grammar_correction.dart';

class GrammarCorrectionModel extends GrammarCorrection {
  const GrammarCorrectionModel({
    required String originalText,
    required String correctedText,
    required String explanation,
    required String errorType,
    required int startIndex,
    required int endIndex,
  }) : super(
          originalText: originalText,
          correctedText: correctedText,
          explanation: explanation,
          errorType: errorType,
          startIndex: startIndex,
          endIndex: endIndex,
        );

  factory GrammarCorrectionModel.fromJson(Map<String, dynamic> json) {
    return GrammarCorrectionModel(
      originalText: json['originalText'],
      correctedText: json['correctedText'],
      explanation: json['explanation'],
      errorType: json['errorType'],
      startIndex: json['startIndex'],
      endIndex: json['endIndex'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'originalText': originalText,
      'correctedText': correctedText,
      'explanation': explanation,
      'errorType': errorType,
      'startIndex': startIndex,
      'endIndex': endIndex,
    };
  }
}