import 'dart:async';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:viminsk_assistent/service/speech_to_text/data/datasource/local/speech_to_text_local_datasource.dart';

class SpeechToTextLocalDataSourceImpl implements SpeechToTextLocalDataSource {
  final SpeechToText _speechToText = SpeechToText();
  Timer? _silenceTimer;

  @override
  Future<bool> initialize() async {
    return await _speechToText.initialize();
  }

  @override
  Future<void> startListening(Function(String) onResult) async {
    final options = SpeechListenOptions(
      partialResults: false,
    );

    await _speechToText.listen(
      localeId: "ru_RU",
      listenOptions: options,
      onResult: (result) {
        if (result.finalResult) {
          onResult(result.recognizedWords);
          _resetSilenceTimer(() => onResult(""));
        } else {
          _resetSilenceTimer(() => onResult(""));
        }
      },
    );

    _startSilenceTimer(() {
      onResult("");
      stopListening();
    });
  }

  @override
  Future<void> stopListening() async {
    await _speechToText.stop();
    _cancelSilenceTimer();
  }

  @override
  bool get isListening => _speechToText.isListening;

  void _startSilenceTimer(VoidCallback onStop) {
    _silenceTimer = Timer(const Duration(milliseconds: 2500), () {
      onStop();
    });
  }

  void _resetSilenceTimer(VoidCallback onStop) {
    _cancelSilenceTimer();
    _startSilenceTimer(onStop);
  }

  void _cancelSilenceTimer() {
    _silenceTimer?.cancel();
    _silenceTimer = null;
  }
}
