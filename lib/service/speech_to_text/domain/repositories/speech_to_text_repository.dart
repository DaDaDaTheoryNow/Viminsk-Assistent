import 'package:flutter/material.dart';

abstract class SpeechToTextRepository {
  //offline recognize
  Future<bool> initializeOffline();

  Future<void> startOfflineListeningForCall({
    required VoidCallback onCallAssistant,
  });

  Future<void> stopOfflineListening();

  //online recognize
  Future<void> startOnlineListeningForCommand({
    required Function(double) onSoundLevelChange,
    required VoidCallback onOfflineSpeechRecognized,
    required VoidCallback onOnlineRecognizingError,
    required Function(String) onDone,
  });

  Future<void> stopOnlineListening();
}
