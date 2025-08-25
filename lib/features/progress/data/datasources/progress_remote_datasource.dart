import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/progress_model.dart';

abstract class ProgressRemoteDatasource {
  Future<ProgressModel> getProgress(String userId);
  Future<void> updateConversationProgress(String userId, int conversationsToday);
  Future<void> updateFlashcardProgress(String userId, int flashcardsReviewed);
  Future<void> updateStreakProgress(String userId, int streak);
}

class ProgressRemoteDatasourceImpl implements ProgressRemoteDatasource {
  final FirebaseFirestore firestore;
  ProgressRemoteDatasourceImpl(this.firestore);

  @override
  Future<ProgressModel> getProgress(String userId) async {
    final doc = await firestore.collection('progress').doc(userId).get();
    if (doc.exists) {
      return ProgressModel.fromMap(doc.data()!);
    } else {
      return ProgressModel.empty();
    }
  }

  @override
  Future<void> updateConversationProgress(String userId, int conversationsToday) async {
    final now = DateTime.now();
    final today = '${now.year.toString().padLeft(4, '0')}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
    final docRef = firestore.collection('progress').doc(userId);
    await firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(docRef);
      int newConversationsToday = 1;
      int newStreak = 1;
      String? lastDate;
      int lastStreak = 0;
      if (snapshot.exists) {
        final data = snapshot.data()!;
        lastDate = data['date'];
        lastStreak = data['streak'] ?? 0;
        if (lastDate == today) {
          newConversationsToday = (data['conversationsToday'] ?? 0) + 1;
          newStreak = lastStreak;
        } else {
          // Check if yesterday was lastDate for streak
          final yesterday = now.subtract(const Duration(days: 1));
          final yesterdayStr = '${yesterday.year.toString().padLeft(4, '0')}-${yesterday.month.toString().padLeft(2, '0')}-${yesterday.day.toString().padLeft(2, '0')}';
          if (lastDate == yesterdayStr) {
            newStreak = lastStreak + 1;
          } else {
            newStreak = 1;
          }
        }
      }
      transaction.set(docRef, {
        'conversationsToday': newConversationsToday,
        'date': today,
        'streak': newStreak,
      }, SetOptions(merge: true));
    });
  }

  @override
  Future<void> updateFlashcardProgress(String userId, int flashcardsReviewed) async {
    final now = DateTime.now();
    final today = '${now.year.toString().padLeft(4, '0')}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
    final docRef = firestore.collection('progress').doc(userId);
    await firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(docRef);
      int newFlashcardsReviewed = 1;
      int newStreak = 1;
      String? lastDate;
      int lastStreak = 0;
      if (snapshot.exists) {
        final data = snapshot.data()!;
        lastDate = data['date'];
        lastStreak = data['streak'] ?? 0;
        if (lastDate == today) {
          newFlashcardsReviewed = (data['flashcardsReviewed'] ?? 0) + 1;
          newStreak = lastStreak;
        } else {
          // Check if yesterday was lastDate for streak
          final yesterday = now.subtract(const Duration(days: 1));
          final yesterdayStr = '${yesterday.year.toString().padLeft(4, '0')}-${yesterday.month.toString().padLeft(2, '0')}-${yesterday.day.toString().padLeft(2, '0')}';
          if (lastDate == yesterdayStr) {
            newStreak = lastStreak + 1;
          } else {
            newStreak = 1;
          }
        }
      }
      transaction.set(docRef, {
        'flashcardsReviewed': newFlashcardsReviewed,
        'date': today,
        'streak': newStreak,
      }, SetOptions(merge: true));
    });
  }

  @override
  Future<void> updateStreakProgress(String userId, int streak) async {
    final now = DateTime.now();
    final today = '${now.year.toString().padLeft(4, '0')}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
    final docRef = firestore.collection('progress').doc(userId);
    await firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(docRef);
      int newStreak = 1;
      String? lastDate;
      int lastStreak = 0;
      if (snapshot.exists) {
        final data = snapshot.data()!;
        lastDate = data['date'];
        lastStreak = data['streak'] ?? 0;
        final yesterday = now.subtract(const Duration(days: 1));
        final yesterdayStr = '${yesterday.year.toString().padLeft(4, '0')}-${yesterday.month.toString().padLeft(2, '0')}-${yesterday.day.toString().padLeft(2, '0')}';
        if (lastDate == yesterdayStr) {
          newStreak = lastStreak + 1;
        } else {
          newStreak = 1;
        }
      }
      transaction.set(docRef, {
        'streak': newStreak,
        'date': today,
      }, SetOptions(merge: true));
    });
  }
}
