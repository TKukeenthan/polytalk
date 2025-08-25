import 'package:equatable/equatable.dart';
import '../../domain/entities/language.dart';

abstract class LanguageEvent extends Equatable {
  const LanguageEvent();

  @override
  List<Object> get props => [];
}

class LoadAvailableLanguages extends LanguageEvent {}

class SelectLanguage extends LanguageEvent {
  final Language language;

  const SelectLanguage(this.language);

  @override
  List<Object> get props => [language];
}

class GetSavedLanguage extends LanguageEvent {}