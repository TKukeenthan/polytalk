import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/flashcard_model.dart';

abstract class FlashcardLocalDataSource {
  Future<List<FlashcardModel>> getFlashcards(String language);
  Future<void> saveFlashcard(FlashcardModel flashcard);
}

const CACHED_FLASHCARDS_PREFIX = 'CACHED_FLASHCARDS_';

class FlashcardLocalDataSourceImpl implements FlashcardLocalDataSource {
  final SharedPreferences sharedPreferences;

  FlashcardLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<List<FlashcardModel>> getFlashcards(String language) {
    final key = '$CACHED_FLASHCARDS_PREFIX$language';
    final jsonStringList = sharedPreferences.getStringList(key);
    
    if (jsonStringList != null) {
      final flashcards = jsonStringList
          .map((jsonString) => FlashcardModel.fromJson(json.decode(jsonString)))
          .toList();
      return Future.value(flashcards);
    } else {
      // Return empty list if no flashcards are cached for this language
      return Future.value([]);
    }
  }

  @override
  Future<void> saveFlashcard(FlashcardModel flashcard) async {
    final key = '$CACHED_FLASHCARDS_PREFIX${flashcard.language}';
    final flashcards = await getFlashcards(flashcard.language);

    // Check if flashcard already exists and update it, otherwise add it.
    final index = flashcards.indexWhere((f) => f.id == flashcard.id);
    if (index != -1) {
      flashcards[index] = flashcard;
    } else {
      flashcards.add(flashcard);
    }
    
    final jsonStringList = flashcards
        .map((card) => json.encode(card.toJson()))
        .toList();

    await sharedPreferences.setStringList(key, jsonStringList);
  }
}