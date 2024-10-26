import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:viminsk_assistent/service/speech_action/domain/repositories/speech_action_repository.dart';
import 'package:viminsk_assistent/service/speech_to_text/domain/repositories/speech_to_text_repository.dart';
import 'package:viminsk_assistent/service/speech_to_text/presentation/provider/state/speech_to_text_state.dart';

class SpeechToTextNotifier extends StateNotifier<SpeechToTextState> {
  final SpeechToTextRepository speechToTextRepository;
  final SpeechActionRepository speechActionRepository;
  SpeechToTextNotifier(this.speechToTextRepository, this.speechActionRepository)
      : super(const SpeechToTextState());

  Future<bool> initialize() async {
    if (await _requestMicrophonePermission()) {
      return await speechToTextRepository.initialize();
    } else {
      return false;
    }
  }

  Future<void> startListening() async {
    await speechToTextRepository.startListening(
      onResult: (words) => state = state.copyWith(recognizedWords: words),
      onSoundLevelChange: (value) => state = state.copyWith(soundLevel: value),
      onDone: () async {
        if (state.recognizedWords.isNotEmpty) {
          final resultString = await speechActionRepository
              .processCommand(state.recognizedWords);

          state = state.copyWith(
            speechActionResult: resultString,
          );
        }

        stopListening();
      },
    );

    state = state.copyWith(isListening: true, recognizedWords: "");
  }

  Future<void> stopListening() async {
    await speechToTextRepository.stopListening();
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
