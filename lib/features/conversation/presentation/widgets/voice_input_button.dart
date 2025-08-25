import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/speech_bloc.dart';
import '../bloc/speech_event.dart';
import '../bloc/speech_state.dart';

class VoiceInputButton extends StatelessWidget {
  final Function(String) onVoiceInput;
  final String targetLanguage;

  const VoiceInputButton({
    Key? key,
    required this.onVoiceInput,
    required this.targetLanguage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SpeechBloc, SpeechState>(
      listener: (context, state) {
        if (state is SpeechRecognized) {
          onVoiceInput(state.text);
        } else if (state is SpeechError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Speech error: ${state.message}')),
          );
        }
      },
      builder: (context, state) {
        final isListening = state is SpeechListening;
        
        return GestureDetector(
          onTapDown: (_) {
            if (!isListening) {
              context.read<SpeechBloc>().add(
                StartListeningEvent(targetLanguage),
              );
            }
          },
          onTapUp: (_) {
            if (isListening) {
              context.read<SpeechBloc>().add(
                const StopListeningEvent(),
              );
            }
          },
          onTapCancel: () {
            if (isListening) {
              context.read<SpeechBloc>().add(
                const StopListeningEvent(),
              );
            }
          },
          child: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: isListening
                  ? Colors.red
                  : Theme.of(context).colorScheme.secondary,
              shape: BoxShape.circle,
              boxShadow: isListening
                  ? [
                      BoxShadow(
                        color: Colors.red.withOpacity(0.3),
                        blurRadius: 8,
                        spreadRadius: 2,
                      ),
                    ]
                  : null,
            ),
            child: Icon(
              isListening ? Icons.mic : Icons.mic_none,
              color: Colors.white,
              size: 24,
            ),
          ),
        );
      },
    );
  }
}