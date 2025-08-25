import 'package:flutter/material.dart';
import '../../domain/entities/message.dart';
import '../../../../core/utils/app_colors.dart';
import 'grammar_correction_widget.dart';

class MessageBubble extends StatelessWidget {
  final Message message;
  final String targetLanguage;
  final VoidCallback? onLongPress;

  const MessageBubble({
    Key? key,
    required this.message,
    required this.targetLanguage,
    this.onLongPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: onLongPress,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          mainAxisAlignment: message.isFromUser
              ? MainAxisAlignment.end
              : MainAxisAlignment.start,
          children: [
            if (!message.isFromUser) _buildAvatar(context),
            Flexible(
              child: Container(
                margin: EdgeInsets.only(
                  left: message.isFromUser ? 64 : 8,
                  right: message.isFromUser ? 8 : 64,
                ),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: message.isFromUser
                      ? AppColors.userMessage
                      : AppColors.aiMessage,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      message.content,
                      style: TextStyle(
                        color: message.isFromUser
                            ? Colors.white
                            : Colors.black87,
                        fontSize: 16,
                      ),
                    ),
                    if (message.corrections != null && message.corrections!.isNotEmpty)
                      ...message.corrections!.map(
                        (correction) => GrammarCorrectionWidget(
                          correction: correction,
                        ),
                      ),
                    const SizedBox(height: 4),
                    Text(
                      _formatTime(message.timestamp),
                      style: TextStyle(
                        color: message.isFromUser
                            ? Colors.white70
                            : Colors.black54,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (message.isFromUser) _buildAvatar(context),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar(BuildContext context) {
    return Container(
      width: 32,
      height: 32,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: message.isFromUser
            ? AppColors.primary
            : AppColors.secondary,
        shape: BoxShape.circle,
      ),
      child: Icon(
        message.isFromUser ? Icons.person : Icons.smart_toy,
        color: Colors.white,
        size: 16,
      ),
    );
  }

  String _formatTime(DateTime timestamp) {
    return '${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}';
  }
}