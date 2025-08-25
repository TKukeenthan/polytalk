import 'package:equatable/equatable.dart';
import '../../domain/entities/language.dart';

abstract class LanguageState extends Equatable {
  const LanguageState();

  @override
  List<Object> get props => [];
}

class LanguageInitial extends LanguageState {}

class LanguageLoading extends LanguageState {}

class LanguagesLoaded extends LanguageState {
  final List<Language> languages;

  const LanguagesLoaded(this.languages);

  @override
  List<Object> get props => [languages];
}

class LanguageSelected extends LanguageState {
  final Language language;

  const LanguageSelected(this.language);

  @override
  List<Object> get props => [language];
}

class LanguageError extends LanguageState {
  final String message;

  const LanguageError(this.message);

  @override
  List<Object> get props => [message];
}