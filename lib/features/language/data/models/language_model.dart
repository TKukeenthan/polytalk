import '../../domain/entities/language.dart';

class LanguageModel extends Language {
  const LanguageModel({
    required String code,
    required String name,
  }) : super(code: code, name: name);

  factory LanguageModel.fromJson(Map<String, dynamic> json) {
    return LanguageModel(
      code: json['code'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'name': name,
    };
  }
}