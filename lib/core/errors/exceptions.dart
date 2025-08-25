class ServerException implements Exception {
  final String message;
  const ServerException(this.message);
}

class CacheException implements Exception {}

class NetworkException implements Exception {}

class SubscriptionException implements Exception {
  final String message;
  const SubscriptionException(this.message);
}

class SpeechException implements Exception {
  final String message;
  const SpeechException(this.message);
}