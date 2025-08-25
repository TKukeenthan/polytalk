import 'package:equatable/equatable.dart';
import '../../domain/entities/flashcard.dart';

abstract class FlashcardEvent extends Equatable {
  const FlashcardEvent();

  @override
  List<Object> get props => [];
}

class LoadFlashcards extends FlashcardEvent {
  final String language;

  const LoadFlashcards(this.language);

  @override
  List<Object> get props => [language];
}

class AddFlashcard extends FlashcardEvent {
  final String text;
  final String language;

  const AddFlashcard({required this.text, required this.language});
  
  @override
  List<Object> get props => [text, language];
}

class UpdateFlashcardPractice extends FlashcardEvent {
  final Flashcard flashcard;

  const UpdateFlashcardPractice(this.flashcard);

  @override
  List<Object> get props => [flashcard];
}