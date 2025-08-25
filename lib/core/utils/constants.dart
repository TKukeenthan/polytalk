class AppConstants {
  // API URLs
  static const String openAIBaseUrl = 'https://openrouter.ai/api/v1/';
  static const String geminiBaseUrl = 'https://generativelanguage.googleapis.com/v1beta';
  
  // RevenueCat
  static const String revenueCatApiKey = 'goog_MbtZpyfCMvBVjJTkJgBMVzThJHr';
  
  // Subscription limits
  static const int freeConversationsPerDay = 5;
  
  // Supported languages
  static const List<String> supportedLanguages = [
    'English',
    'Spanish',
    'French',
    'German',
    'Mandarin',
    'Japanese',
    'Korean',
    'Italian',
    'Portuguese',
    'Russian'
  ];
  
  // Storage keys
  static const String targetLanguageKey = 'target_language';
  static const String conversationCountKey = 'conversation_count';
  static const String lastResetDateKey = 'last_reset_date';
}