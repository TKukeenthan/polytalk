import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:polytalk/core/utils/app_colors.dart';
import '../../domain/entities/flashcard.dart';
import '../bloc/flashcard_bloc.dart';
import '../bloc/flashcard_event.dart';
import '../widgets/flashcard_widget.dart';
import '../../../progress/presentation/bloc/progress_bloc.dart';
import '../../../progress/presentation/bloc/progress_event.dart';

class FlashcardPracticePage extends StatefulWidget {
  final List<Flashcard> flashcards;

  const FlashcardPracticePage({
    Key? key,
    required this.flashcards,
  }) : super(key: key);

  @override
  _FlashcardPracticePageState createState() => _FlashcardPracticePageState();
}

class _FlashcardPracticePageState extends State<FlashcardPracticePage> {
  int _currentIndex = 0;

  void _nextCard() {
    setState(() {
      if (_currentIndex < widget.flashcards.length - 1) {
        _currentIndex++;
      } else {
        // End of practice session
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Practice session complete!')),
        );
      }
    });
  }

  void _handlePractice(Flashcard card) {
    context.read<FlashcardBloc>().add(UpdateFlashcardPractice(card));
    // Update flashcard reviewed progress
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userId = user.uid;
      context.read<ProgressBloc>().add(UpdateFlashcardProgressEvent(userId, 1));
    }
    _nextCard();
  }

  @override
  Widget build(BuildContext context) {
    final currentCard = widget.flashcards[_currentIndex];
    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: Text('Practice (${_currentIndex + 1}/${widget.flashcards.length})'),
          backgroundColor: AppColors.primary,
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
          elevation: 0.0,
        ),
        body: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth > 900;
            final isTablet = constraints.maxWidth > 600 && constraints.maxWidth <= 900;
            final cardMaxWidth = isWide ? 600.0 : isTablet ? 480.0 : double.infinity;
            final cardMaxHeight = isWide ? 420.0 : isTablet ? 340.0 : double.infinity;
            final horizontalPad = isWide ? 64.0 : isTablet ? 32.0 : 8.0;
            final verticalPad = isWide ? 48.0 : isTablet ? 24.0 : 8.0;
            return Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).colorScheme.primary.withOpacity(0.12),
                    Theme.of(context).colorScheme.surfaceVariant,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: isWide ? 800 : isTablet ? 600 : double.infinity,
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: horizontalPad,
                      vertical: verticalPad,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: Center(
                            child: Card(
                              elevation: 12,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(36)),
                              color: Colors.transparent,
                              shadowColor: Theme.of(context).colorScheme.primary.withOpacity(0.18),
                              child: Container(
                                constraints: BoxConstraints(
                                  maxWidth: cardMaxWidth,
                                  maxHeight: cardMaxHeight,
                                ),
                                child: FlashcardWidget(flashcard: currentCard),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),
                        isWide
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: _ModernPracticeButton(
                                      label: 'I knew this',
                                      icon: Icons.check_circle_outline,
                                      color: Colors.green,
                                      onTap: () => _handlePractice(currentCard),
                                    ),
                                  ),
                                  const SizedBox(width: 40),
                                  Expanded(
                                    child: _ModernPracticeButton(
                                      label: 'I didn\'t know',
                                      icon: Icons.cancel_outlined,
                                      color: Colors.red,
                                      onTap: () => _handlePractice(currentCard),
                                    ),
                                  ),
                                ],
                              )
                            : Column(
                                children: [
                                  _ModernPracticeButton(
                                    label: 'I knew this',
                                    icon: Icons.check_circle_outline,
                                    color: Colors.green,
                                    onTap: () => _handlePractice(currentCard),
                                  ),
                                  const SizedBox(height: 16),
                                  _ModernPracticeButton(
                                    label: 'I didn\'t know',
                                    icon: Icons.cancel_outlined,
                                    color: Colors.red,
                                    onTap: () => _handlePractice(currentCard),
                                  ),
                                ],
                              ),
                        const SizedBox(height: 32),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: LinearProgressIndicator(
                              value: (_currentIndex + 1) / widget.flashcards.length,
                              backgroundColor: Colors.grey[200],
                              color: Theme.of(context).colorScheme.primary,
                              minHeight: 10,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Center(
                          child: Text(
                            'Progress: ${_currentIndex + 1} / ${widget.flashcards.length}',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _ModernPracticeButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  const _ModernPracticeButton({required this.label, required this.icon, required this.color, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, color: Colors.white),
      label: Text(label, style: const TextStyle(color: Colors.white)),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        elevation: 2,
      ),
    );
  }
}