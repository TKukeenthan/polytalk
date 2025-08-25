import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import '../../domain/entities/message.dart';

class ConversationHistoryService {
  final FirebaseFirestore firestore;
  ConversationHistoryService({required this.firestore});

  Future<void> saveConversation(String conversationId, List<Message> messages, {String? name}) async {
    final user = firebase_auth.FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception('User not logged in');
    final ref = firestore.collection('users').doc(user.uid).collection('conversations').doc(conversationId);
    await ref.set({
      'conversationId': conversationId,
      'name': name ?? '',
      'timestamp': DateTime.now().toIso8601String(),
      'messages': messages.map((m) => _messageToJson(m)).toList(),
    });
  }

  Map<String, dynamic> _messageToJson(Message m) => {
    'id': m.id,
    'content': m.content,
    'isFromUser': m.isFromUser,
    'timestamp': m.timestamp.toIso8601String(),
    'audioUrl': m.audioUrl,
    // Add corrections if needed
  };

  Future<List<Map<String, dynamic>>> getConversations() async {
    final user = firebase_auth.FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception('User not logged in');
    final snapshot = await firestore.collection('users').doc(user.uid).collection('conversations').orderBy('timestamp', descending: true).get();
    return snapshot.docs.map((doc) {
      final data = doc.data();
      data['conversationId'] = doc.id;
      return data;
    }).toList();
  }

  Future<List<Message>> loadConversation(String conversationId) async {
    final user = firebase_auth.FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception('User not logged in');
    final doc = await firestore.collection('users').doc(user.uid).collection('conversations').doc(conversationId).get();
    final data = doc.data();
    if (data == null) return [];
    return (data['messages'] as List).map((m) => Message(
      id: m['id'],
      content: m['content'],
      isFromUser: m['isFromUser'],
      timestamp: DateTime.parse(m['timestamp']),
      audioUrl: m['audioUrl'],
    )).toList();
  }
}
