import 'package:flutter/material.dart';

abstract class SpeechToTextRepository {
  Future<bool> initialize();

  Future<void> startListening({
    required Function(String) onResult,
    required Function(double) onSoundLevelChange,
    required VoidCallback onDone,
  });

  Future<void> stopListening();
}
