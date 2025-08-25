import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/utils/constants.dart';
import '../models/language_model.dart';

abstract class LanguageLocalDataSource {
  Future<List<LanguageModel>> getAvailableLanguages();
  Future<void> setTargetLanguage(LanguageModel language);
  Future<LanguageModel> getTargetLanguage();
}

class LanguageLocalDataSourceImpl implements LanguageLocalDataSource {
  final SharedPreferences sharedPreferences;

  LanguageLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<List<LanguageModel>> getAvailableLanguages() async {
    // In a real app, this might come from a remote config or be hardcoded
    return AppConstants.supportedLanguages
        .map((lang) => LanguageModel(code: lang.substring(0,2).toLowerCase(), name: lang))
        .toList();
  }
  
  @override
  Future<void> setTargetLanguage(LanguageModel language) async {
    try {
      await sharedPreferences.setString(
        AppConstants.targetLanguageKey,
        json.encode(language.toJson()),
      );
    } catch (e) {
      throw CacheException();
    }
  }
  
  @override
  Future<LanguageModel> getTargetLanguage() {
    final jsonString = sharedPreferences.getString(AppConstants.targetLanguageKey);
    if (jsonString != null) {
      return Future.value(LanguageModel.fromJson(json.decode(jsonString)));
    } else {
      throw CacheException();
    }
  }
}