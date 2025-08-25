import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'progress_event.dart';
import 'progress_state.dart';
import '../../domain/usecases/get_progress.dart';
import '../../domain/usecases/update_conversation_progress.dart';
import '../../domain/usecases/update_flashcard_progress.dart';
import '../../domain/usecases/update_streak_progress.dart';

class ProgressBloc extends Bloc<ProgressEvent, ProgressState> {
  final GetProgress getProgress;
  final UpdateConversationProgress updateConversationProgress;
  final UpdateFlashcardProgress updateFlashcardProgress;
  final UpdateStreakProgress updateStreakProgress;

  ProgressBloc({
    required this.getProgress,
    required this.updateConversationProgress,
    required this.updateFlashcardProgress,
    required this.updateStreakProgress,
  }) : super(ProgressInitial()) {
    on<LoadProgress>((event, emit) async {
      emit(ProgressLoading());
      try {
        final progress = await getProgress(event.userId);
        emit(ProgressLoaded(progress));
      } catch (e) {
        emit(ProgressError(e.toString()));
      }
    });
    on<UpdateConversationProgressEvent>((event, emit) async {
      try {
        final currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
        final state = this.state;
        int newCount = 1;
        if (state is ProgressLoaded) {
          // If the date is today, increment; else, reset to 1
          if (state.progress is dynamic && state.progress.date == currentDate) {
            newCount = state.progress.conversationsToday + 1;
          } else {
            newCount = 1;
          }
        }
        await updateConversationProgress(event.userId, newCount);
        add(LoadProgress(event.userId));
      } catch (e) {
        emit(ProgressError(e.toString()));
      }
    });
    on<UpdateFlashcardProgressEvent>((event, emit) async {
      try {
        await updateFlashcardProgress(event.userId, event.flashcardsReviewed);
        add(LoadProgress(event.userId));
      } catch (e) {
        emit(ProgressError(e.toString()));
      }
    });
    on<UpdateStreakProgressEvent>((event, emit) async {
      try {
        await updateStreakProgress(event.userId, event.streak);
        add(LoadProgress(event.userId));
      } catch (e) {
        emit(ProgressError(e.toString()));
      }
    });
  }
}
