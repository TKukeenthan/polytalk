import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:polytalk/firebase_options.dart';

import 'core/theme/app_theme.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/bloc/auth_state.dart';
import 'features/conversation/presentation/bloc/conversation_bloc.dart';
import 'features/language/presentation/bloc/language_bloc.dart';
import 'features/conversation/presentation/bloc/speech_bloc.dart';
import 'features/flashcards/presentation/bloc/flashcard_bloc.dart';
import 'features/progress/presentation/bloc/progress_bloc.dart';
import 'features/subscription/presentation/bloc/subscription_bloc.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'features/conversation/presentation/pages/home_page.dart';
import 'features/subscription/presentation/bloc/subscription_event.dart';
import 'injection.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        name: 'polytalk',
        options: DefaultFirebaseOptions.currentPlatform,
      );
    }
  
  // Initialize dependency injection
  await di.init();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (_) => di.sl<AuthBloc>(),
        ),
        BlocProvider<LanguageBloc>(
          create: (_) => di.sl<LanguageBloc>(),
        ),
        BlocProvider<ConversationBloc>(
          create: (_) => di.sl<ConversationBloc>(),
        ),
        BlocProvider<SpeechBloc>(
          create: (_) => di.sl<SpeechBloc>(),
        ),
        BlocProvider<FlashcardBloc>(
          create: (_) => di.sl<FlashcardBloc>(),
        ),
        BlocProvider<ProgressBloc>(
          create: (_) => di.sl<ProgressBloc>(),
        ),
        BlocProvider<SubscriptionBloc>(
          create: (_) => di.sl<SubscriptionBloc>()
            ..add(const CheckSubscriptionStatusEvent()),
        ),
      ],
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is Authenticated) {
            return MaterialApp(
              title: 'AI Language Coach',
              theme: AppTheme.lightTheme,
              home: const HomePage(),
              debugShowCheckedModeBanner: false,
            );
          } else {
            return MaterialApp(
              title: 'AI Language Coach',
              theme: AppTheme.lightTheme,
              home: const LoginPage(),
              debugShowCheckedModeBanner: false,
            );
          }
        },
      ),
    );
  }
}