import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:viminsk_assistent/utils/window_size.dart';

class ListeningButton extends ConsumerWidget {
  final VoidCallback onStartRecording;
  final VoidCallback onStopRecording;
  final bool isListening;

  const ListeningButton({
    required this.onStartRecording,
    required this.onStopRecording,
    required this.isListening,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      onTap: isListening ? onStopRecording : onStartRecording,
      borderRadius: BorderRadius.circular(isListening ? 25 : 28),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: isListening
            ? WindowSize(context).width * 0.5
            : WindowSize(context).width * 0.2,
        height: isListening
            ? WindowSize(context).height * 0.1
            : WindowSize(context).height * 0.09,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              isListening
                  ? Colors.redAccent
                  : const Color.fromARGB(255, 49, 47, 47),
              isListening
                  ? const Color.fromARGB(255, 41, 40, 40)
                  : const Color.fromARGB(255, 82, 81, 81),
            ],
          ),
          borderRadius: BorderRadius.circular(isListening ? 25 : 28),
        ),
        child: Center(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (Widget child, Animation<double> animation) =>
                ScaleTransition(scale: animation, child: child),
            child: Icon(
              isListening ? Icons.more_horiz : Icons.mic,
              key: ValueKey<bool>(isListening),
              color: Colors.white,
              size: isListening ? 40 : 35,
            ),
          ),
        ),
      ),
    );
  }
}
