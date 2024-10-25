import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
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
    final isListining = ref.watch(speechToTextNotifierProvider);
    final speechToTextNotifier =
        ref.read(speechToTextNotifierProvider.notifier);

    return Scaffold(
      body: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: Text(
              isListining ? "Слушаю..." : "Готов слушать !",
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: ListeningButton(
              onPressed: () async {
                if (await speechToTextNotifier.initialize()) {
                  speechToTextNotifier.startListening((text) {
                    print("Recognized text: $text");
                  });
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
