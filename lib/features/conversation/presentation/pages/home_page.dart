import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:polytalk/features/language/domain/entities/language.dart';
import 'package:polytalk/features/language/presentation/bloc/language_event.dart';
import '../../../language/presentation/bloc/language_bloc.dart';
import '../../../language/presentation/bloc/language_state.dart';
import '../../../subscription/presentation/bloc/subscription_bloc.dart';
import '../../../subscription/presentation/bloc/subscription_state.dart';
import 'conversation_page.dart';
import '../../../language/presentation/pages/language_selection_page.dart';
import '../../../subscription/presentation/pages/subscription_page.dart';
import '../../../flashcards/presentation/pages/flashcards_page.dart';
import '../../../auth/presentation/pages/profile_page.dart';
import '../../../progress/presentation/widgets/progress_widget.dart';
import '../../../ads/widgets/banner_ad_widget.dart';
import '../../../ads/widgets/rewarded_ad_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    context.read<LanguageBloc>().add(SelectLanguage(Language(code: 'en', name: 'English')));
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Language Coach'),
        actions: [
          IconButton(
            onPressed: () {
              RewardedAdWidget.load(
                adUnitId:
                    'ca-app-pub-3940256099942544/5224354917', // Test rewarded ad unit ID
                onRewarded: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SubscriptionPage(),
                    ),
                  );
                },
                onAdClosed: () {},
              );
            },
            icon: const Icon(Icons.star),
          ),
          IconButton(
            onPressed: () {
              RewardedAdWidget.load(
                adUnitId:
                    'ca-app-pub-3940256099942544/5224354917', // Test rewarded ad unit ID
                onRewarded: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const FlashcardsPage(),
                    ),
                  );
                },
                onAdClosed: () {},
              );
            },
            icon: const Icon(Icons.quiz),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfilePage()),
              );
            },
            icon: const Icon(Icons.person),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<LanguageBloc, LanguageState>(
              builder: (context, languageState) {
                FirebaseAuth instance = FirebaseAuth.instance;
                final user = instance.currentUser;
                if (user == null) {
                  // Handle unauthenticated state, e.g., navigate to login page
                  return Center(
                    child: ElevatedButton(
                      onPressed: () {
                        // Navigate to login page
                        // TODO: Implement navigation to login page
                      },
                      child: const Text('Please log in'),
                    ),
                  );
                }
                final userId = user.uid;
                if (languageState is LanguageSelected) {
                  return _buildMainContent(
                    context,
                    languageState.language.name,
                    userId,
                  );
                } else {
                  return _buildMainContent(context, 'english', userId);
                }
              },
            ),
          ),
          // Banner Ad at the bottom
          BannerAdWidget(
            adUnitId: 'ca-app-pub-3940256099942544/6300978111',
          ), // Test ad unit ID
        ],
      ),
    );
  }

  Widget _buildMainContent(
    BuildContext context,
    String targetLanguage,
    String userId,
  ) {
    return BlocBuilder<SubscriptionBloc, SubscriptionState>(
      builder: (context, subscriptionState) {
        final isProUser = subscriptionState is SubscriptionActive;
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildWelcomeCard(targetLanguage),
              const SizedBox(height: 24),
              _buildQuickActions(context, targetLanguage),
              const SizedBox(height: 24),
              ProgressWidget(isProUser: isProUser, userId: userId),
              const SizedBox(height: 24),
              // if (!isProUser) _buildUpgradePrompt(context),
            ],
          ),
        );
      },
    );
  }

  Widget _buildWelcomeCard(String targetLanguage) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome back!',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Ready to practice $targetLanguage today?',
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context, String targetLanguage) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quick Actions',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildActionCard(
                context,
                'Start Conversation',
                Icons.chat,
                () {
                  RewardedAdWidget.load(
                    adUnitId:
                        'ca-app-pub-3940256099942544/5224354917', // Test rewarded ad unit ID
                    onRewarded: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ConversationPage(targetLanguage: targetLanguage),
                        ),
                      );
                    },
                    onAdClosed: () {},
                  );
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildActionCard(
                context,
                'Practice Flashcards',
                Icons.quiz,
                () {
                  RewardedAdWidget.load(
                    adUnitId:
                        'ca-app-pub-3940256099942544/5224354917', // Test rewarded ad unit ID
                    onRewarded: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const FlashcardsPage(),
                        ),
                      );
                    },
                    onAdClosed: () {},
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionCard(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback onTap,
  ) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Icon(
                icon,
                size: 32,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 8),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUpgradePrompt(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(
              Icons.star,
              size: 32,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 8),
            const Text(
              'Upgrade to Pro',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            const Text(
              'Get unlimited conversations and detailed feedback',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SubscriptionPage(),
                ),
              ),
              child: const Text('Learn More'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageSelectionPrompt(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.language,
              size: 64,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 16),
            const Text(
              'Choose Your Target Language',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Select the language you want to learn and start practicing!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const LanguageSelectionPage(),
                ),
              ),
              child: const Text('Select Language'),
            ),
          ],
        ),
      ),
    );
  }
}
