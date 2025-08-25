import 'package:flutter/material.dart';
import '../../domain/entities/flashcard.dart';

class FlashcardWidget extends StatefulWidget {
  final Flashcard flashcard;

  const FlashcardWidget({Key? key, required this.flashcard}) : super(key: key);

  @override
  _FlashcardWidgetState createState() => _FlashcardWidgetState();
}

class _FlashcardWidgetState extends State<FlashcardWidget> {
  bool _isFlipped = false;

  void _flipCard() {
    setState(() {
      _isFlipped = !_isFlipped;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _flipCard,
      child: Card(
        elevation: 8,
        child: Container(
          width: double.infinity,
          height: 300,
          alignment: Alignment.center,
          padding: const EdgeInsets.all(24),
          child: Text(
            _isFlipped ? widget.flashcard.backText : widget.flashcard.frontText,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}