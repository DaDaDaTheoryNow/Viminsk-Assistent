import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:viminsk_assistent/service/speech_to_text/domain/repositories/speech_to_text_repository.dart';
import 'package:viminsk_assistent/service/speech_to_text/presentation/provider/state/speech_to_text_state.dart';

class SpeechToTextNotifier extends StateNotifier<SpeechToTextState> {
  final SpeechToTextRepository repository;
  SpeechToTextNotifier(this.repository) : super(const SpeechToTextState());

  Future<bool> initialize() async {
    if (await _requestMicrophonePermission()) {
      return await repository.initialize();
    } else {
      return false;
    }
  }

  Future<void> startListening(Function(String) onResult) async {
    await repository.startListening(
      onResult: onResult,
      onSoundLevelChange: (value) => state = state.copyWith(soundLevel: value),
      onDone: () => stopListening(),
    );

    state = state.copyWith(isListening: true);
  }

  Future<void> stopListening() async {
    await repository.stopListening();
    state = state.copyWith(isListening: false, soundLevel: 0.0);
  }

  Future<bool> _requestMicrophonePermission() async {
    if (await Permission.microphone.request() == PermissionStatus.denied) {
      return false;
    } else {
      return true;
    }
  }
}
