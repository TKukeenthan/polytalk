import '../../domain/entities/flashcard.dart';

class FlashcardModel extends Flashcard {
  const FlashcardModel({
    required String id,
    required String frontText,
    required String backText,
    required String language,
    required String difficulty,
    required DateTime createdAt,
    DateTime? lastReviewed,
    int reviewCount = 0,
    double easeFactor = 2.5,
    int interval = 1,
  }) : super(
          id: id,
          frontText: frontText,
          backText: backText,
          language: language,
          difficulty: difficulty,
          createdAt: createdAt,
          lastReviewed: lastReviewed,
          reviewCount: reviewCount,
          easeFactor: easeFactor,
          interval: interval,
        );

  factory FlashcardModel.fromJson(Map<String, dynamic> json) {
    return FlashcardModel(
      id: json['id'],
      frontText: json['frontText'],
      backText: json['backText'],
      language: json['language'],
      difficulty: json['difficulty'],
      createdAt: DateTime.parse(json['createdAt']),
      lastReviewed: json['lastReviewed'] != null ? DateTime.parse(json['lastReviewed']) : null,
      reviewCount: json['reviewCount'],
      easeFactor: json['easeFactor'],
      interval: json['interval'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'frontText': frontText,
      'backText': backText,
      'language': language,
      'difficulty': difficulty,
      'createdAt': createdAt.toIso8601String(),
      'lastReviewed': lastReviewed?.toIso8601String(),
      'reviewCount': reviewCount,
      'easeFactor': easeFactor,
      'interval': interval,
    };
  }
}