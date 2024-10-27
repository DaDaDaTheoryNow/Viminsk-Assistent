import 'package:flutter_tts/flutter_tts.dart';

import '../../domain/repositories/text_to_speech_repository.dart';

class TextToSpeechRepositoryImpl extends TextToSpeechRepository {
  final FlutterTts flutterTts = FlutterTts();

  @override
  Future<void> speak(String text) async {
    await flutterTts.setLanguage("ru-RU");
    await flutterTts.setPitch(1.0);
    await flutterTts.setSpeechRate(0.5);

    await flutterTts.speak(text);
  }

  @override
  Future<void> stop() async {
    await flutterTts.stop();
  }
}
