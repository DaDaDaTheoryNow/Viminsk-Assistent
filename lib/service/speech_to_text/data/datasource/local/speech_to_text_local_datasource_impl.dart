import 'dart:async';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:viminsk_assistent/service/speech_to_text/data/datasource/local/speech_to_text_local_datasource.dart';

class SpeechToTextLocalDataSourceImpl implements SpeechToTextLocalDataSource {
  final SpeechToText _speechToText = SpeechToText();

  @override
  Future<bool> initialize() async {
    return await _speechToText.initialize();
  }

  @override
  Future<void> startListening({
    required Function(String) onResult,
    required Function(double) onSoundLevelChange,
    required VoidCallback onDone,
  }) async {
    final options = SpeechListenOptions(
      partialResults: false,
    );

    _speechToText.statusListener = (String status) {
      if (status == "done") onDone();
    };

    await _speechToText.listen(
      localeId: "ru_RU",
      listenOptions: options,
      onSoundLevelChange: onSoundLevelChange,
      onResult: (result) {
        if (result.finalResult) {
          onResult(result.recognizedWords);
        }
      },
    );
  }

  @override
  Future<void> stopListening() async {
    await _speechToText.stop();
  }
}
