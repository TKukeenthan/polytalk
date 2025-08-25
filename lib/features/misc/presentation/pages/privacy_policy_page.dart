import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Privacy Policy')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: const [
          Text('Privacy Policy', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
          SizedBox(height: 16),
          Text('We value your privacy. Your data is stored securely and is never sold to third parties. We only collect information necessary to provide and improve our language learning services.'),
          SizedBox(height: 12),
          Text('• We do not share your personal information with advertisers.'),
          Text('• Conversations and progress are stored securely in the cloud.'),
          Text('• You can request deletion of your data at any time.'),
          SizedBox(height: 12),
          Text('For questions, contact us at support@polytalk.app.'),
        ],
      ),
    );
  }
}
