import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:viminsk_assistent/service/speech_to_text/domain/repositories/speech_to_text_repository.dart';

class SpeechToTextNotifier extends StateNotifier<bool> {
  final SpeechToTextRepository repository;
  SpeechToTextNotifier(this.repository) : super(false);

  Future<bool> initialize() async {
    if (await _requestMicrophonePermission()) {
      return await repository.initialize();
    } else {
      return false;
    }
  }

  Future<void> startListening(Function(String) onResult) async {
    await repository.startListening((String value) {
      if (value.isNotEmpty) {
        onResult(value);
      }

      stopListening();
    });

    state = repository.isListening;
  }

  Future<void> stopListening() async {
    await repository.stopListening();
    state = repository.isListening;
  }

  Future<bool> _requestMicrophonePermission() async {
    if (await Permission.microphone.request() == PermissionStatus.denied) {
      return false;
    } else {
      return true;
    }
  }
}
