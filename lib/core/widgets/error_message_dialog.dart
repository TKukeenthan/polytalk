import 'package:flutter/material.dart';

class ErrorMessageDialog extends StatelessWidget {
  final String message;
  final String? title;
  final VoidCallback? onDismiss;

  const ErrorMessageDialog({
    Key? key,
    required this.message,
    this.title,
    this.onDismiss,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title ?? 'Error', style: const TextStyle(color: Colors.red)),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            if (onDismiss != null) onDismiss!();
          },
          child: const Text('OK'),
        ),
      ],
    );
  }
}

class LoadingMessageBubble extends StatelessWidget {
  final String text;
  const LoadingMessageBubble({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
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
                  child: Text(
                    text,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.grey),
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
    );
  }
}
