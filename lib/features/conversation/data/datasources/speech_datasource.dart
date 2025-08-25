import 'package:speech_to_text/speech_to_text.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../../../../core/errors/exceptions.dart';

abstract class SpeechDataSource {
  Future<String> speechToText(String? localeId);
  Future<String> textToSpeech(String text, String language);
  Future<bool> isListening();
  Future<void> startListening();
  Future<void> stopListening();
}

class SpeechDataSourceImpl implements SpeechDataSource {
  final SpeechToText _speechToText = SpeechToText();
  final FlutterTts _flutterTts = FlutterTts();
  String _lastRecognizedWords = '';
  bool _isListening = false;

  SpeechDataSourceImpl() {
    _initializeTts();
  }

  Future<void> _initializeTts() async {
    await _flutterTts.setSharedInstance(true);
    await _flutterTts.setIosAudioCategory(
      IosTextToSpeechAudioCategory.playback,
      [
        IosTextToSpeechAudioCategoryOptions.allowBluetooth,
        IosTextToSpeechAudioCategoryOptions.allowBluetoothA2DP,
        IosTextToSpeechAudioCategoryOptions.mixWithOthers
      ],
    );
  }

  @override
  Future<String> speechToText(String? localeId) async {
    try {
      bool available = await _speechToText.initialize(
        onStatus: (status) {
          _isListening = status == 'listening';
        },
        onError: (error) {
          throw SpeechException('Speech recognition error: ${error.errorMsg}');
        },
      );

      if (!available) {
        throw SpeechException('Speech recognition not available');
      }

      await _speechToText.listen(
        onResult: (result) {
          _lastRecognizedWords = result.recognizedWords;
        },
        localeId: localeId,
      );

      // Wait for speech recognition to complete
      while (_isListening) {
        await Future.delayed(const Duration(milliseconds: 100));
      }

      return _lastRecognizedWords;
    } catch (e) {
      throw SpeechException('Failed to convert speech to text: $e');
    }
  }

  @override
  Future<String> textToSpeech(String text, String language) async {
    try {
      // Set language based on target language
      String ttsLanguage = _getTtsLanguageCode(language);
      await _flutterTts.setLanguage(ttsLanguage);
      await _flutterTts.setSpeechRate(0.5);
      await _flutterTts.setVolume(1.0);
      await _flutterTts.setPitch(1.0);

      await _flutterTts.speak(text);

      // Return a placeholder audio URL (in real implementation, you might save to file)
      return 'audio_played_successfully';
    } catch (e) {
      throw SpeechException('Failed to convert text to speech: $e');
    }
  }

  @override
  Future<bool> isListening() async {
    return _isListening;
  }

  @override
  Future<void> startListening() async {
    try {
      bool available = await _speechToText.initialize();
      if (available) {
        await _speechToText.listen(
          onResult: (result) {
            _lastRecognizedWords = result.recognizedWords;
          },
        );
        _isListening = true;
      }
    } catch (e) {
      throw SpeechException('Failed to start listening: $e');
    }
  }

  @override
  Future<void> stopListening() async {
    try {
      await _speechToText.stop();
      _isListening = false;
    } catch (e) {
      throw SpeechException('Failed to stop listening: $e');
    }
  }

  String _getTtsLanguageCode(String language) {
    switch (language.toLowerCase()) {
      case 'spanish':
        return 'es-ES';
      case 'french':
        return 'fr-FR';
      case 'german':
        return 'de-DE';
      case 'mandarin':
        return 'zh-CN';
      case 'japanese':
        return 'ja-JP';
      case 'korean':
        return 'ko-KR';
      case 'italian':
        return 'it-IT';
      case 'portuguese':
        return 'pt-PT';
      case 'russian':
        return 'ru-RU';
      default:
        return 'en-US';
    }
  }
}