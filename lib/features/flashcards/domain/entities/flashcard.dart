import 'package:equatable/equatable.dart';

class Flashcard extends Equatable {
  final String id;
  final String frontText;
  final String backText;
  final String language;
  final String difficulty;
  final DateTime createdAt;
  final DateTime? lastReviewed;
  final int reviewCount;
  final double easeFactor;
  final int interval;

  const Flashcard({
    required this.id,
    required this.frontText,
    required this.backText,
    required this.language,
    required this.difficulty,
    required this.createdAt,
    this.lastReviewed,
    this.reviewCount = 0,
    this.easeFactor = 2.5,
    this.interval = 1,
  });

  @override
  List<Object?> get props => [
        id,
        frontText,
        backText,
        language,
        difficulty,
        createdAt,
        lastReviewed,
        reviewCount,
        easeFactor,
        interval,
      ];
}