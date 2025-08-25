import 'package:intl/intl.dart';

import '../../domain/entities/progress.dart';

class ProgressModel extends Progress {
  const ProgressModel({
    required int conversationsToday,
    required int flashcardsReviewed,
    required int streak,
    required String date,
  }) : super(
          conversationsToday: conversationsToday,
          flashcardsReviewed: flashcardsReviewed,
          streak: streak,
          date: date,
        );

  factory ProgressModel.fromMap(Map<String, dynamic> map) {
    return ProgressModel(
      conversationsToday: map['conversationsToday'] ?? 0,
      flashcardsReviewed: map['flashcardsReviewed'] ?? 0,
      streak: map['streak'] ?? 0,
      date: map['date'] ?? DateFormat('yyyy-MM-dd').format(DateTime.now()),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'conversationsToday': conversationsToday,
      'flashcardsReviewed': flashcardsReviewed,
      'streak': streak,
      'date': date,
    };
  }

  factory ProgressModel.empty() => ProgressModel(
        conversationsToday: 0,
        flashcardsReviewed: 0,
        streak: 0,
        date: DateFormat('yyyy-MM-dd').format(DateTime.now()),
      );
}
