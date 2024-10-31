import 'package:flutter/material.dart';

abstract class SpeechToTextLocalDataSourceRepository {
  Future<bool> initializeVosk();

  Future<void> startOfflineListeningForCall({
    required VoidCallback onCallAssistant,
  });

  Future<void> stopOfflineListening();
}
