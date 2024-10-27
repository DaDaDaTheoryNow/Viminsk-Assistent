import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:viminsk_assistent/features/home/presentation/widgets/sound_level_visualizer.dart';
import 'package:viminsk_assistent/service/speech_to_text/presentation/provider/speech_to_text_notifier_provider.dart';

import 'widgets/listening_button.dart';

class HomeScreen extends ConsumerWidget {
  static HomeScreen builder(
    BuildContext context,
    GoRouterState state,
  ) =>
      const HomeScreen();

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final speechActionResult =
        ref.watch(speechToTextNotifierProvider).speechActionResult;
    final isListening = ref.watch(speechToTextNotifierProvider).isListening;
    final isLoading = ref.watch(speechToTextNotifierProvider).isLoading;
    final soundLevel = ref.watch(speechToTextNotifierProvider).soundLevel;
    final recognizedWords =
        ref.watch(speechToTextNotifierProvider).recognizedWords;

    final speechToTextNotifier =
        ref.read(speechToTextNotifierProvider.notifier);

    return Scaffold(
      floatingActionButton: ListeningButton(
        isListening: isListening,
        onStartRecording: () async {
          if (await speechToTextNotifier.initialize()) {
            speechToTextNotifier.startListening();
          }
        },
        onStopRecording: () =>
            speechToTextNotifier.stopListening(isForceCancel: true),
      ),
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // sound visualizer
              AnimatedOpacity(
                opacity: isLoading
                    ? 0.0
                    : isListening
                        ? 1.0
                        : 0.0,
                duration: const Duration(milliseconds: 300),
                child: Center(
                  child: SoundLevelVisualizer(
                    soundLevel: soundLevel,
                  ),
                ),
              ),

              // result of question
              AnimatedOpacity(
                opacity: isLoading
                    ? 0.0
                    : isListening
                        ? 0.0
                        : 1.0,
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeIn,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Text(
                      speechActionResult,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),

              // recognized words
              AnimatedOpacity(
                opacity: isLoading
                    ? 0.0
                    : isListening
                        ? 1.0
                        : 0.0,
                duration: const Duration(milliseconds: 250),
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      recognizedWords.isNotEmpty ? recognizedWords : '',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

          // loading
          AnimatedOpacity(
            opacity: isLoading ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 300),
            child: const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
