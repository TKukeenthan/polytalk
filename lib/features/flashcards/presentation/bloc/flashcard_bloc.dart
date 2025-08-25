
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/generate_flashcard.dart';
import '../../domain/usecases/get_flashcards.dart';
import '../../domain/usecases/practice_flashcard.dart';
import 'flashcard_event.dart';
import 'flashcard_state.dart';

class FlashcardBloc extends Bloc<FlashcardEvent, FlashcardState> {
  final GenerateFlashcard generateFlashcard;
  final GetFlashcards getFlashcards;
  final PracticeFlashcard practiceFlashcard;

  FlashcardBloc({
    required this.generateFlashcard,
    required this.getFlashcards,
    required this.practiceFlashcard,
  }) : super(FlashcardInitial()) {
    on<LoadFlashcards>(_onLoadFlashcards);
    on<AddFlashcard>(_onAddFlashcard);
    on<UpdateFlashcardPractice>(_onUpdateFlashcardPractice);
  }

  Future<void> _onLoadFlashcards(
    LoadFlashcards event,
    Emitter<FlashcardState> emit,
  ) async {
    emit(FlashcardLoading());
    final result = await getFlashcards(event.language);
    result.fold(
      (failure) => emit(FlashcardError(failure.toString())),
      (flashcards) => emit(FlashcardLoaded(flashcards)),
    );
  }

  Future<void> _onAddFlashcard(
    AddFlashcard event,
    Emitter<FlashcardState> emit,
  ) async {
    final result = await generateFlashcard(
        GenerateFlashcardParams(text: event.text, language: event.language));
    result.fold(
      (failure) => emit(FlashcardError(failure.toString())),
      (flashcard) {
        // After adding, reload the list of flashcards
        add(LoadFlashcards(event.language));
      },
    );
  }

  Future<void> _onUpdateFlashcardPractice(
    UpdateFlashcardPractice event,
    Emitter<FlashcardState> emit,
  ) async {
    await practiceFlashcard(event.flashcard);
  }
}