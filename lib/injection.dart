import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// Core

// Features - Auth
import 'features/auth/data/datasources/auth_remote_datasource.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/domain/usecases/auth_usecases.dart';
import 'features/auth/domain/usecases/log_out_user.dart';
import 'features/auth/domain/usecases/login_user.dart';
import 'features/auth/domain/usecases/register_user.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';

// Features - Language
import 'features/language/data/datasources/language_local_datasource.dart';
import 'features/language/data/repositories/language_repository_impl.dart';
import 'features/language/domain/repositories/language_repository.dart';
import 'features/language/domain/usecases/get_available_languages.dart';
import 'features/language/domain/usecases/set_target_language.dart';
import 'features/language/presentation/bloc/language_bloc.dart';

// Features - Conversation
import 'features/conversation/data/datasources/ai_remote_datasource.dart';
import 'features/conversation/data/datasources/speech_datasource.dart';
import 'features/conversation/data/datasources/conversation_local_datasource.dart';
import 'features/conversation/data/repositories/conversation_repository_impl.dart';
import 'features/conversation/domain/repositories/conversation_repository.dart';
import 'features/conversation/domain/usecases/send_message.dart';
import 'features/conversation/domain/usecases/get_ai_response.dart';
import 'features/conversation/domain/usecases/speech_to_text.dart';
import 'features/conversation/domain/usecases/text_to_speech.dart';
import 'features/conversation/presentation/bloc/conversation_bloc.dart';
import 'features/conversation/presentation/bloc/speech_bloc.dart';

// Features - Flashcards
import 'features/flashcards/data/datasources/flashcard_remote_datasource.dart';
import 'features/flashcards/data/datasources/flashcard_local_datasource.dart';
import 'features/flashcards/data/repositories/flashcard_repository_impl.dart';
import 'features/flashcards/domain/repositories/flashcard_repository.dart';
import 'features/flashcards/domain/usecases/generate_flashcard.dart';
import 'features/flashcards/domain/usecases/get_flashcards.dart';
import 'features/flashcards/domain/usecases/practice_flashcard.dart';
import 'features/flashcards/presentation/bloc/flashcard_bloc.dart';

// Features - Subscription
import 'features/subscription/data/datasources/revenue_cat_datasource.dart';
import 'features/subscription/data/repositories/subscription_repository_impl.dart';
import 'features/subscription/domain/repositories/subscription_repository.dart';
import 'features/subscription/domain/usecases/get_subscription_status.dart';
import 'features/subscription/domain/usecases/purchase_subscription.dart';
import 'features/subscription/domain/usecases/restore_purchases.dart';
import 'features/subscription/presentation/bloc/subscription_bloc.dart';

// Features - Progress
import 'features/progress/data/datasources/progress_remote_datasource.dart';
import 'features/progress/data/repositories/progress_repository_impl.dart';
import 'features/progress/domain/repositories/progress_repository.dart';
import 'features/progress/domain/usecases/get_progress.dart';
import 'features/progress/domain/usecases/update_conversation_progress.dart';
import 'features/progress/domain/usecases/update_flashcard_progress.dart';
import 'features/progress/domain/usecases/update_streak_progress.dart';
import 'features/progress/presentation/bloc/progress_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // External dependencies
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => FirebaseAuth.instance);
  // Auth feature
  await MobileAds.instance.initialize();

  _initAuth();

  // Language feature
  _initLanguage();

  // Conversation feature
  _initConversation();

  // Flashcards feature
  _initFlashcards();

  // Subscription feature
  _initSubscription();

  // Progress feature
  _initProgress();
}

void _initAuth() {
  // Bloc
  sl.registerFactory(
    () => AuthBloc(
      loginUser: sl(),
      registerUser: sl(),
      logoutUser: sl(), signInWithGoogle: sl(), sendPasswordResetEmail: sl(), sendEmailVerification: sl(), // Add logoutUser
    ),
  );

  // Use cases
    sl.registerLazySingleton(() => SignInWithGoogle(sl()));
    sl.registerLazySingleton(() => SendPasswordResetEmail(sl()));
    sl.registerLazySingleton(() => SendEmailVerification(sl()));

  sl.registerLazySingleton(() => LoginUser(sl()));
  sl.registerLazySingleton(() => RegisterUser(sl()));
  sl.registerLazySingleton(() => LogoutUser(sl())); // Register new usecase

  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    // Update this to use FirebaseAuth instead of http.Client
    () => AuthRemoteDataSourceImpl(firebaseAuth: sl()),
  );
}

void _initLanguage() {
  // Bloc
  sl.registerFactory(
    () => LanguageBloc(getAvailableLanguages: sl(), setTargetLanguage: sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => GetAvailableLanguages(sl()));
  sl.registerLazySingleton(() => SetTargetLanguage(sl()));

  // Repository
  sl.registerLazySingleton<LanguageRepository>(
    () => LanguageRepositoryImpl(localDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<LanguageLocalDataSource>(
    () => LanguageLocalDataSourceImpl(sharedPreferences: sl()),
  );
}

void _initConversation() {
  // Blocs
  sl.registerFactory(
    () => ConversationBloc(sendMessage: sl(), getAIResponse: sl()),
  );

  sl.registerFactory(() => SpeechBloc(speechToText: sl(), textToSpeech: sl()));

  // Use cases
  sl.registerLazySingleton(() => SendMessage(sl()));
  sl.registerLazySingleton(() => GetAIResponse(sl()));
  sl.registerLazySingleton(() => SpeechToTextUseCase(sl()));
  sl.registerLazySingleton(() => TextToSpeechUseCase(sl()));

  // Repository
  sl.registerLazySingleton<ConversationRepository>(
    () => ConversationRepositoryImpl(
      aiRemoteDataSource: sl(),
      speechDataSource: sl(),
      localDataSource: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<AIRemoteDataSource>(
    () => AIRemoteDataSourceImpl(
      client: sl(),
      apiKey:
          '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',
    ),
  );

  sl.registerLazySingleton<SpeechDataSource>(() => SpeechDataSourceImpl());

  sl.registerLazySingleton<ConversationLocalDataSource>(
    () => ConversationLocalDataSourceImpl(sharedPreferences: sl()),
  );
}

void _initFlashcards() {
  // Bloc
  sl.registerFactory(
    () => FlashcardBloc(
      generateFlashcard: sl(),
      getFlashcards: sl(),
      practiceFlashcard: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GenerateFlashcard(sl()));
  sl.registerLazySingleton(() => GetFlashcards(sl()));
  sl.registerLazySingleton(() => PracticeFlashcard(sl()));

  // Repository
  sl.registerLazySingleton<FlashcardRepository>(
    () =>
        FlashcardRepositoryImpl(remoteDataSource: sl(), localDataSource: sl()),
  );
  sl.registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance);

  // Data sources
  sl.registerLazySingleton<FlashcardRemoteDataSource>(
    () => FlashcardRemoteDataSourceImpl(firestore: sl()),
  );

  sl.registerLazySingleton<FlashcardLocalDataSource>(
    () => FlashcardLocalDataSourceImpl(sharedPreferences: sl()),
  );
}

void _initSubscription() {
  // Data sources
  sl.registerLazySingleton<RevenueCatDataSource>(
    () => RevenueCatDataSourceImpl(),
  );
  // Bloc
  sl.registerFactory(
    () => SubscriptionBloc(
      getSubscriptionStatus: sl(),
      purchaseSubscription: sl(),
      restorePurchases: sl(),
    ),
  );
  // Repository
  sl.registerLazySingleton<SubscriptionRepository>(
    () => SubscriptionRepositoryImpl(dataSource: sl()),
  );
  // Use cases
  sl.registerLazySingleton(() => GetSubscriptionStatus(sl()));
  sl.registerLazySingleton(() => PurchaseSubscription(sl()));
  sl.registerLazySingleton(() => RestorePurchases(sl()));
}

void _initProgress() {
  // Data source
  sl.registerLazySingleton<ProgressRemoteDatasource>(
    () => ProgressRemoteDatasourceImpl(sl<FirebaseFirestore>()),
  );
  // Repository
  sl.registerLazySingleton<ProgressRepository>(
    () => ProgressRepositoryImpl(sl()),
  );
  // Use cases
  sl.registerLazySingleton(() => GetProgress(sl()));
  sl.registerLazySingleton(() => UpdateConversationProgress(sl()));
  sl.registerLazySingleton(() => UpdateFlashcardProgress(sl()));
  sl.registerLazySingleton(() => UpdateStreakProgress(sl()));

  // Bloc
  sl.registerFactory(
    () => ProgressBloc(
      getProgress: sl(),
      updateConversationProgress: sl(),
      updateFlashcardProgress: sl(),
      updateStreakProgress: sl(),
    ),
  );
}
