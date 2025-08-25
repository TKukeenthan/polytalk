import 'package:flutter/material.dart';

class FAQPage extends StatelessWidget {
  const FAQPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('How to Use - FAQ')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: const [
          _FAQItem(
            question: 'How do I start a conversation?',
            answer: 'Tap the "+" icon in the top right to start a new conversation. Type or use voice input to send your message.'
          ),
          _FAQItem(
            question: 'How do I save a conversation?',
            answer: 'Tap the save icon in the app bar. You can name and save your conversation for later review.'
          ),
          _FAQItem(
            question: 'How do I add a message to flashcards?',
            answer: 'Long-press any message and select "Add to Flashcards".'
          ),
          _FAQItem(
            question: 'How do I review my progress?',
            answer: 'Your daily progress and streaks are shown on the home screen and profile.'
          ),
          _FAQItem(
            question: 'How do I use voice input?',
            answer: 'Tap the microphone icon next to the message input field.'
          ),
          _FAQItem(
            question: 'How do I see my conversation history?',
            answer: 'Tap the history icon in the app bar to view all saved conversations.'
          ),
        ],
      ),
    );
  }
}

class _FAQItem extends StatelessWidget {
  final String question;
  final String answer;
  const _FAQItem({required this.question, required this.answer});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(question, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(answer, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}
