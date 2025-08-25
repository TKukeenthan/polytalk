import 'package:http/http.dart' as http;
import '../models/flashcard_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import '../models/flashcard_model.dart';
abstract class FlashcardRemoteDataSource {
  Future<void> syncFlashcards(List<FlashcardModel> flashcards);
}

// This is a placeholder implementation. A real app would sync with a backend like Firestore.


class FlashcardRemoteDataSourceImpl implements FlashcardRemoteDataSource {
  final FirebaseFirestore firestore;

  FlashcardRemoteDataSourceImpl({required this.firestore});

  @override
  Future<void> syncFlashcards(List<FlashcardModel> flashcards) async {
    final user = firebase_auth.FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception('User not logged in');

    final flashcardsRef = firestore.collection('users').doc(user.uid).collection('flashcards');

    // Optionally clear old flashcards first:
    final batch = firestore.batch();
    final existing = await flashcardsRef.get();
    for (final doc in existing.docs) {
      batch.delete(doc.reference);
    }
    for (final flashcard in flashcards) {
      final doc = flashcardsRef.doc(flashcard.id); // or .doc() for auto-id
      batch.set(doc, flashcard.toJson());
    }
    await batch.commit();
  }

  Future<List<FlashcardModel>> loadFlashcards() async {
    final user = firebase_auth.FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception('User not logged in');

    final snapshot = await firestore.collection('users').doc(user.uid).collection('flashcards').get();
    return snapshot.docs.map((doc) => FlashcardModel.fromJson(doc.data())).toList();
  }
}