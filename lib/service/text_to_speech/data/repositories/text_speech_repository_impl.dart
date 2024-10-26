import 'package:flutter_tts/flutter_tts.dart';

import '../../domain/repositories/text_speech_repository.dart';

class TextSpeechRepositoryImpl extends TextSpeechRepository {
  final FlutterTts flutterTts = FlutterTts();

  @override
  Future<void> speak(String text) async {
    await flutterTts.setLanguage("ru-RU");
    await flutterTts.setPitch(1.0); // Настраиваем высоту голоса
    await flutterTts.setSpeechRate(0.5); // Настраиваем скорость речи

    await flutterTts.speak(text);
  }

  @override
  Future<void> stop() async {
    await flutterTts.stop();
  }
}
