import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/flashcard_bloc.dart';
import '../bloc/flashcard_event.dart';
import '../bloc/flashcard_state.dart';
import 'flashcard_practice_page.dart';
import '../widgets/flashcard_list_item.dart';
import '../../../language/presentation/bloc/language_bloc.dart';
import '../../../language/presentation/bloc/language_state.dart';
import '../../../ads/widgets/banner_ad_widget.dart';

class FlashcardsPage extends StatefulWidget {
  const FlashcardsPage({Key? key}) : super(key: key);

  @override
  _FlashcardsPageState createState() => _FlashcardsPageState();
}

class _FlashcardsPageState extends State<FlashcardsPage> {
  @override
  void initState() {
    super.initState();
    // Load flashcards for the selected language from LanguageBloc
    final languageState = context.read<LanguageBloc>().state;
    String targetLanguage = 'english';
    if (languageState is LanguageSelected) {
      targetLanguage = languageState.language.name;
    }
    context.read<FlashcardBloc>().add(LoadFlashcards(targetLanguage));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flashcards'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            tooltip: 'How to use flashcards',
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Flashcards Tips'),
                  content: const Text('Long-press a flashcard to edit or delete. Practice regularly to improve your memory!'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('OK'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<FlashcardBloc, FlashcardState>(
        builder: (context, state) {
          if (state is FlashcardLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is FlashcardLoaded) {
            if (state.flashcards.isEmpty) {
              return const Center(child: Text('No flashcards yet.'));
            }
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => FlashcardPracticePage(flashcards: state.flashcards),
                        ),
                      );
                    },
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('Start Practice Session'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Theme.of(context).colorScheme.onPrimary,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      elevation: 2,
                    ),
                  ),
                ),
                Expanded(
                  child: Card(
                    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    elevation: 2,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      itemCount: state.flashcards.length,
                      separatorBuilder: (_, __) => const Divider(height: 1, indent: 16, endIndent: 16),
                      itemBuilder: (context, index) {
                        return FlashcardListItem(flashcard: state.flashcards[index]);
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                // Banner Ad at the bottom
                BannerAdWidget(adUnitId: 'ca-app-pub-3940256099942544/6300978111'),
                const SizedBox(height: 8),
              ],
            );
          } else if (state is FlashcardError) {
            return Center(child: Text('Error: \\${state.message}'));
          }
          return const Center(child: Text('Your flashcards will appear here.'));
        },
      ),
    );
  }
}