import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:viminsk_assistent/service/speech_to_text/presentation/provider/speech_to_text_notifier_provider.dart';
import 'package:viminsk_assistent/utils/window_size.dart';

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
    final isListening = ref.watch(speechToTextNotifierProvider).isListening;
    final speechToTextNotifier =
        ref.read(speechToTextNotifierProvider.notifier);

    final List<String> messages = [
      "Привет! Чем могу помочь?",
      "Какой сегодня день?",
      "Сегодня среда.",
      "Спасибо!",
      "Пожалуйста!",
    ];

    return Scaffold(
      floatingActionButton: ListeningButton(
        isListening: isListening,
        onStartRecording: () async {
          if (await speechToTextNotifier.initialize()) {
            speechToTextNotifier.startListening((text) {
              print("Recognized text: $text");
            });
          }
        },
        onStopRecording: () => speechToTextNotifier.stopListening(),
      ),
      body: ListView.builder(
        itemCount: messages.length,
        itemBuilder: (context, index) {
          if (index < messages.length - 1) {
            return Container(
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: index.isEven ? Colors.blueGrey : Colors.greenAccent[400],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                messages[0],
                style: const TextStyle(color: Colors.white),
              ),
            );
          } else {
            return SizedBox(height: WindowSize(context).height * 0.12);
          }
        },
      ),
    );
  }
}
