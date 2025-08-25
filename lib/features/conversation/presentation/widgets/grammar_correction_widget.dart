import 'package:flutter/material.dart';
import '../../domain/entities/grammar_correction.dart';
import '../../../../core/utils/app_colors.dart';

class GrammarCorrectionWidget extends StatelessWidget {
  final GrammarCorrection correction;

  const GrammarCorrectionWidget({
    Key? key,
    required this.correction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColors.grammarError,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.red.withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.error_outline,
                size: 16,
                color: Colors.red[700],
              ),
              const SizedBox(width: 4),
              Text(
                'Grammar Correction',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.red[700],
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          RichText(
            text: TextSpan(
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 14,
              ),
              children: [
                const TextSpan(
                  text: 'Original: ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text: correction.originalText,
                  style: const TextStyle(
                    decoration: TextDecoration.lineThrough,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 2),
          RichText(
            text: TextSpan(
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 14,
              ),
              children: [
                const TextSpan(
                  text: 'Correct: ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text: correction.correctedText,
                  style: const TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            correction.explanation,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.black54,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}