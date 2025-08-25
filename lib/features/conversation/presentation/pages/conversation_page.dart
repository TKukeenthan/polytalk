import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:polytalk/features/misc/presentation/pages/faq_page.dart';
import '../../../progress/presentation/bloc/progress_state.dart';
import '../../domain/entities/message.dart';
import '../bloc/conversation_bloc.dart';
import '../bloc/conversation_event.dart';
import '../bloc/conversation_state.dart';
import '../widgets/message_bubble.dart';
import '../widgets/voice_input_button.dart';
import '../../../flashcards/presentation/bloc/flashcard_bloc.dart';
import '../../../flashcards/presentation/bloc/flashcard_event.dart';
import '../../data/datasources/conversation_history_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'conversation_history_page.dart';
import '../../../progress/presentation/bloc/progress_bloc.dart';
import '../../../progress/presentation/bloc/progress_event.dart';
import '../../../ads/widgets/banner_ad_widget.dart';
import '../../../ads/widgets/rewarded_ad_widget.dart';
import 'package:polytalk/core/widgets/error_message_dialog.dart';

class ConversationPage extends StatefulWidget {
  final String targetLanguage;

  const ConversationPage({Key? key, required this.targetLanguage})
    : super(key: key);

  @override
  State<ConversationPage> createState() => _ConversationPageState();
}

class _ConversationPageState extends State<ConversationPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  String _conversationId = DateTime.now().millisecondsSinceEpoch.toString();
  String? _conversationName;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is Map) {
      final messages = args['messages'] as List?;
      final conversationId = args['conversationId'] as String?;
      final conversationName = args['conversationName'] as String?;
      if (messages != null && conversationId != null) {
        _conversationId = conversationId;
        _conversationName = conversationName;
        // Set the loaded messages in the bloc
        context.read<ConversationBloc>().emit(
          ConversationLoaded(List.castFrom<dynamic, Message>(messages)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [

            Text('Practice ${widget.targetLanguage}', style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [
          Tooltip(
            message: 'Start New Conversation',
            child: IconButton(
              icon: const Icon(Icons.add),
              onPressed: () async {
                final state = context.read<ConversationBloc>().state;
                if (state is ConversationLoaded && state.messages.isNotEmpty) {
                  final shouldSave = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Save Conversation?'),
                      content: const Text('Do you want to save the current conversation before starting a new one?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text('No'),
                        ),
                        ElevatedButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: const Text('Save'),
                        ),
                      ],
                    ),
                  );
                  if (shouldSave == true) {
                    RewardedAdWidget.load(
                      adUnitId: 'ca-app-pub-3940256099942544/5224354917',
                      onRewarded: () async {
                        await _saveCurrentConversation();
                        _startNewConversation();
                      },
                      onAdClosed: () async {
                        await _saveCurrentConversation();
                        _startNewConversation();
                      },
                    );
                    return;
                  }
                }
                _startNewConversation();
              },
            ),
          ),
          Tooltip(
            message: 'Save Conversation',
            child: IconButton(
              icon: const Icon(Icons.save),
              onPressed: () async {
                final state = context.read<ConversationBloc>().state;
                if (state is ConversationLoaded && state.messages.isNotEmpty) {
                  if (_conversationName == null || _conversationName!.isEmpty) {
                    String? conversationName = await showDialog<String>(
                      context: context,
                      builder: (context) {
                        final controller = TextEditingController();
                        return AlertDialog(
                          title: const Text('Name this conversation'),
                          content: TextField(
                            controller: controller,
                            decoration: const InputDecoration(
                              hintText: 'Conversation name',
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Cancel'),
                            ),
                            ElevatedButton(
                              onPressed: () => Navigator.pop(context, controller.text.trim()),
                              child: const Text('Save'),
                            ),
                          ],
                        );
                      },
                    );
                    if (conversationName != null && conversationName.isNotEmpty) {
                      _conversationName = conversationName;
                    } else {
                      return;
                    }
                  }
                  final service = ConversationHistoryService(
                    firestore: FirebaseFirestore.instance,
                  );
                  await service.saveConversation(
                    _conversationId,
                    state.messages,
                    name: _conversationName,
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Conversation saved!')),
                  );
                }
              },
            ),
          ),
          Tooltip(
            message: 'Conversation History',
            child: IconButton(
              icon: const Icon(Icons.history),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => ConversationHistoryPage()),
                );
              },
            ),
          ),
        ],
        elevation: 0.5,
        backgroundColor: Theme.of(context).colorScheme.surface,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.07),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Today: Practice, Learn, and Chat!',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      InkWell(
                        child: Icon(Icons.lightbulb, color: Theme.of(context).colorScheme.primary, size: 24),
                        onTap: () {
                          // Show tip dialog or snackbar
                          showModalBottomSheet(
                            isScrollControlled: true,
                            useSafeArea: true,
                            context: context, builder: (_)=>FAQPage());
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: const [
                        _TipChip(icon: Icons.save, text: 'Tip: Save your best chats for review!'),
                        SizedBox(width: 8),
                        _TipChip(icon: Icons.star, text: 'Tip: Add useful phrases to flashcards.'),
                        SizedBox(width: 8),
                        _TipChip(icon: Icons.mic, text: 'Tip: Try voice input for faster practice!'),
                        SizedBox(width: 8),
                        _TipChip(icon: Icons.history, text: 'Tip: Review your conversation history.'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: BlocBuilder<ConversationBloc, ConversationState>(
                builder: (context, state) {
                  if (state is ConversationLoaded) {
                    if (state.messages.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.chat, size: 64, color: Theme.of(context).colorScheme.primary.withOpacity(0.2)),
                            const SizedBox(height: 16),
                            Text('Start chatting in ${widget.targetLanguage}!', style: Theme.of(context).textTheme.titleMedium),
                            const SizedBox(height: 8),
                            Text('Type or use voice to send your first message.', style: Theme.of(context).textTheme.bodyMedium),
                          ],
                        ),
                      );
                    }
                    return ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(16),
                      itemCount: state.isLoading
                          ? state.messages.length + 3
                          : state.messages.length + (state.isLoading ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (state.isLoading && index == state.messages.length) {
                          // Show shimmer effect for user's last message
                          final lastUserMessage = state.messages.isNotEmpty ? state.messages.last.content : '';
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                  backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                                  child: Icon(Icons.person, color: Theme.of(context).colorScheme.primary),
                                ),
                                const SizedBox(width: 8),
                                Flexible(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                    margin: const EdgeInsets.symmetric(vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).colorScheme.surfaceVariant,
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Stack(
                                            children: [
                                              Opacity(
                                                opacity: 0.5,
                                                child: Text(
                                                  lastUserMessage,
                                                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.grey),
                                                ),
                                              ),
                                              Positioned.fill(
                                                child: Align(
                                                  alignment: Alignment.bottomLeft,
                                                  child: SizedBox(
                                                    height: 12,
                                                    child: _ShimmerBar(),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        const SizedBox(
                                          width: 16,
                                          height: 16,
                                          child: CircularProgressIndicator(strokeWidth: 2),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                        if (state.isLoading && index > state.messages.length) {
                          // Shimmer for AI response
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                                  child: Icon(Icons.smart_toy, color: Theme.of(context).colorScheme.primary),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Container(
                                    height: 32,
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.5),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: const Align(
                                      alignment: Alignment.centerLeft,
                                      child: _ShimmerBar(),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                        if (index < state.messages.length) {
                          final message = state.messages[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: MessageBubble(
                              message: message,
                              targetLanguage: widget.targetLanguage,
                              onLongPress: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text('Add to Flashcards?'),
                                    content: Text('Add this message as a flashcard?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: const Text('Cancel'),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                          context.read<FlashcardBloc>().add(
                                            AddFlashcard(
                                              text: message.content,
                                              language: widget.targetLanguage,
                                            ),
                                          );
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(content: Text('Flashcard added!')),
                                          );
                                        },
                                        child: const Text('Add'),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    );
                  } else if (state is ConversationError) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      showDialog(
                        context: context,
                        builder: (context) => ErrorMessageDialog(message: state.message),
                      );
                    });
                    return const SizedBox.shrink();
                  }
                  return const Center(child: Text('Start a conversation!'));
                },
              ),
            ),
            // Banner Ad at the bottom
            BannerAdWidget(adUnitId: 'ca-app-pub-3940256099942544/6300978111'),
            _buildMessageInput(),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'Type a message in ${widget.targetLanguage}...'
                    '  (Try voice input!)',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                filled: true,
                fillColor: Theme.of(context).colorScheme.surfaceVariant,
              ),
              onSubmitted: _sendMessage,
              textInputAction: TextInputAction.send,
            ),
          ),
          const SizedBox(width: 8),
          Tooltip(
            message: 'Voice Input',
            child: VoiceInputButton(
              onVoiceInput: (text) {
                _messageController.text = text;
                _sendMessage(text);
              },
              targetLanguage: widget.targetLanguage,
            ),
          ),
          const SizedBox(width: 8),
          Tooltip(
            message: 'Send',
            child: IconButton(
              onPressed: () => _sendMessage(_messageController.text),
              icon: const Icon(Icons.send),
              style: IconButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _sendMessage(String text) {
    if (text.trim().isEmpty) return;

    // Show rewarded ad before sending message
          _sendMessageAfterAd(text);

  }

  void _sendMessageAfterAd(String text) {
    context.read<ConversationBloc>().add(
      SendMessageEvent(
        conversationId: _conversationId,
        content: text.trim(),
        targetLanguage: widget.targetLanguage,
      ),
    );
    FirebaseAuth auth = FirebaseAuth.instance;
    final user = auth.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('You must be logged in to send messages.'),
        ),
      );
      return;
    }
    // Update conversation progress for today
    final userId = user.uid;
    final progressBloc = context.read<ProgressBloc>();
    final state = progressBloc.state;
    int newCount = 1;
    if (state is ProgressLoaded) {
      newCount = state.progress.conversationsToday + 1;
    }
    progressBloc.add(UpdateConversationProgressEvent(userId, newCount));

    _messageController.clear();
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _startNewConversation() {
    setState(() {
      _conversationId = DateTime.now().millisecondsSinceEpoch.toString();
      _conversationName = null;
    });
    context.read<ConversationBloc>().add(
      LoadConversationEvent(_conversationId),
    );
  }

  Future<void> _saveCurrentConversation() async {
    final state = context.read<ConversationBloc>().state;
    if (state is ConversationLoaded && state.messages.isNotEmpty) {
      if (_conversationName == null || _conversationName!.isEmpty) {
        String? conversationName = await showDialog<String>(
          context: context,
          builder: (context) {
            final controller = TextEditingController();
            return AlertDialog(
              title: const Text('Name this conversation'),
              content: TextField(
                controller: controller,
                decoration: const InputDecoration(
                  hintText: 'Conversation name',
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context, controller.text.trim()),
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
        if (conversationName != null && conversationName.isNotEmpty) {
          _conversationName = conversationName;
        } else {
          return;
        }
      }
      final service = ConversationHistoryService(
        firestore: FirebaseFirestore.instance,
      );
      await service.saveConversation(
        _conversationId,
        state.messages,
        name: _conversationName,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Conversation saved!')),
      );
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}

// Add shimmer bar widget for loading effect
class _ShimmerBar extends StatefulWidget {
  const _ShimmerBar();
  @override
  State<_ShimmerBar> createState() => _ShimmerBarState();
}

class _ShimmerBarState extends State<_ShimmerBar> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200))..repeat();
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return FractionallySizedBox(
          alignment: Alignment.centerLeft,
          widthFactor: 0.5 + 0.5 * _animation.value,
          child: Container(
            height: 12,
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.25 + 0.25 * _animation.value),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
      },
    );
  }
}

// Add a tip chip widget for user tips
class _TipChip extends StatelessWidget {
  final IconData icon;
  final String text;
  const _TipChip({required this.icon, required this.text});
  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: Icon(icon, size: 18, color: Theme.of(context).colorScheme.primary),
      label: Text(text, style: Theme.of(context).textTheme.bodySmall),
      backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );
  }
}
