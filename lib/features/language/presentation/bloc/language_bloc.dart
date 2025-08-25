import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/usecases/get_available_languages.dart';
import '../../domain/usecases/set_target_language.dart';
import 'language_event.dart';
import 'language_state.dart';

class LanguageBloc extends Bloc<LanguageEvent, LanguageState> {
  final GetAvailableLanguages getAvailableLanguages;
  final SetTargetLanguage setTargetLanguage;

  LanguageBloc({
    required this.getAvailableLanguages,
    required this.setTargetLanguage,
  }) : super(LanguageInitial()) {
    on<LoadAvailableLanguages>(_onLoadAvailableLanguages);
    on<SelectLanguage>(_onSelectLanguage);
  }

  Future<void> _onLoadAvailableLanguages(
    LoadAvailableLanguages event,
    Emitter<LanguageState> emit,
  ) async {
    emit(LanguageLoading());
    final result = await getAvailableLanguages(NoParams());
    result.fold(
      (failure) => emit(LanguageError(failure.toString())),
      (languages) => emit(LanguagesLoaded(languages)),
    );
  }

  Future<void> _onSelectLanguage(
    SelectLanguage event,
    Emitter<LanguageState> emit,
  ) async {
    emit(LanguageLoading());
    final result = await setTargetLanguage(event.language);
    result.fold(
      (failure) => emit(LanguageError(failure.toString())),
      (_) => emit(LanguageSelected(event.language)),
    );
  }
}
