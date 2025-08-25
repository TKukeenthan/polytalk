import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('About PolyTalk')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: const [
          Text('About PolyTalk', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
          SizedBox(height: 16),
          Text('PolyTalk is your AI-powered language learning coach. Practice real conversations, build vocabulary with flashcards, and track your progress every day.'),
          SizedBox(height: 12),
          Text('Features:'),
          Text('• AI chat for real-life language practice'),
          Text('• Flashcards for memorization'),
          Text('• Progress tracking and streaks'),
          Text('• Voice input for hands-free learning'),
          SizedBox(height: 12),
          Text('Made with ❤️ by the PolyTalk Team.'),
        ],
      ),
    );
  }
}
