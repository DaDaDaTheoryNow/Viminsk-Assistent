import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:viminsk_assistent/features/home/presentation/widgets/sound_level_visualizer.dart';
import 'package:viminsk_assistent/service/speech_to_text/presentation/provider/speech_to_text_notifier_provider.dart';

class OverlayWidget extends ConsumerWidget {
  const OverlayWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isListening = ref.watch(speechToTextNotifierProvider).isListening;
    final isLoading = ref.watch(speechToTextNotifierProvider).isLoading;
    final soundLevel = ref.watch(speechToTextNotifierProvider).soundLevel;
    final speechToTextNotifier =
        ref.read(speechToTextNotifierProvider.notifier);

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () async {
              isListening
                  ? await speechToTextNotifier.stopListening()
                  : await speechToTextNotifier.startListening();
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(60),
                gradient: const LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    Color.fromARGB(255, 21, 21, 21),
                    Color.fromARGB(255, 82, 81, 81),
                  ],
                ),
              ),
              child: Center(
                child: AnimatedOpacity(
                  opacity: isLoading
                      ? 0.0
                      : isListening
                          ? 1.0
                          : 0.0,
                  duration: const Duration(milliseconds: 300),
                  child: Center(
                    child: Container(
                      padding: EdgeInsets.all(0),
                      child: SoundLevelVisualizer(
                        soundLevel: soundLevel,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}
