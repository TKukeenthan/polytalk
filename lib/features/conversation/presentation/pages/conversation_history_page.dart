import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../ads/widgets/banner_ad_widget.dart';
import '../../../ads/widgets/interstitial_ad_widget.dart';
import '../../../ads/widgets/rewarded_ad_widget.dart';
import '../../data/datasources/conversation_history_service.dart';
import 'conversation_page.dart';

class ConversationHistoryPage extends StatefulWidget {
  const ConversationHistoryPage({Key? key}) : super(key: key);

  @override
  State<ConversationHistoryPage> createState() => _ConversationHistoryPageState();
}

class _ConversationHistoryPageState extends State<ConversationHistoryPage> {
  late Future<List<Map<String, dynamic>>> _futureConversations;

  @override
  void initState() {
    super.initState();
    // Show interstitial ad when opening history page
    InterstitialAdWidget.load(
      adUnitId: 'ca-app-pub-3940256099942544/1033173712', // Test interstitial ad unit ID
      onAdClosed: () {},
    );
    _futureConversations = ConversationHistoryService(firestore: FirebaseFirestore.instance).getConversations();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Conversation History')),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: _futureConversations,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No saved conversations.'));
                }
                final conversations = snapshot.data!;
                return ListView.builder(
                  itemCount: conversations.length,
                  itemBuilder: (context, index) {
                    final conv = conversations[index];
                    return ListTile(
                      title: Text(conv['name']?.isNotEmpty == true ? conv['name'] : 'Conversation \\${conv['conversationId']}'),
                      subtitle: Text(conv['timestamp'] ?? ''),
                      onTap: () async {
                        RewardedAdWidget.load(
                          adUnitId: 'ca-app-pub-3940256099942544/5224354917', // Test rewarded ad unit ID
                          onRewarded: () async {
                            final messages = await ConversationHistoryService(firestore: FirebaseFirestore.instance)
                                .loadConversation(conv['conversationId']);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ConversationPage(
                                  targetLanguage: '', // You may want to store/retrieve this
                                ),
                                settings: RouteSettings(
                                  arguments: {
                                    'messages': messages,
                                    'conversationId': conv['conversationId'],
                                    'conversationName': conv['name'],
                                  },
                                ),
                              ),
                            );
                          },
                          onAdClosed: () {},
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
          BannerAdWidget(adUnitId: 'ca-app-pub-3940256099942544/6300978111'), // Test banner ad unit ID
        ],
      ),
    );
  }
}
