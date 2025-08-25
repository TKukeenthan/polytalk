import 'package:flutter/material.dart';

class TermsAndConditionsPage extends StatelessWidget {
  const TermsAndConditionsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Terms & Conditions')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: const [
          Text('Terms & Conditions', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
          SizedBox(height: 16),
          Text('By using PolyTalk, you agree to the following terms:'),
          SizedBox(height: 12),
          Text('• You will use the app for personal, non-commercial language learning.'),
          Text('• You will not misuse the app or attempt to access other users’ data.'),
          Text('• We reserve the right to update these terms at any time.'),
          SizedBox(height: 12),
          Text('For questions, contact us at support@polytalk.app.'),
        ],
      ),
    );
  }
}
