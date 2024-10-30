import 'dart:ui';

abstract class SpeechToTextRemoteDataSourceRepository {
  Future<void> startOnlineListeningForCommand({
    required Function(double) onSoundLevelChange,
    required VoidCallback onOfflineSpeechRecognized,
    required VoidCallback onOnlineRecognizingError,
    required Function(String) onDone,
  });

  Future<void> stopOnlineListening();
}
