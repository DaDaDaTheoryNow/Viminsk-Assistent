import 'package:flutter/material.dart';

abstract class SpeechToTextDataSource {
  Future<bool> initialize();

  Future<void> startListening({
    required Function(String) onResult,
    required Function(double) onSoundLevelChange,
    required VoidCallback onDone,
  });

  Future<void> stopListening();
}
