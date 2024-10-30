import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OverlayWidget extends ConsumerWidget {
  const OverlayWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Объявляем локальный канал внутри оверлея
    const platform = MethodChannel('overlay_channel');

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () async {
            try {
              await platform.invokeMethod('startSpeechRecognition');
            } on PlatformException catch (e) {
              print("Ошибка при вызове метода: ${e.message}");
            }
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
                    ])),
          ),
        ),
      ),
    );
  }
}
