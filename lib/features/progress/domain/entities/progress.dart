import 'package:equatable/equatable.dart';

class Progress extends Equatable {
  final int conversationsToday;
  final int flashcardsReviewed;
  final int streak;
  final String? date;

  const Progress({
    required this.conversationsToday,
    required this.flashcardsReviewed,
    required this.streak,
    this.date,
  });

  @override
  List<Object?> get props => [conversationsToday, flashcardsReviewed, streak, date];
}
