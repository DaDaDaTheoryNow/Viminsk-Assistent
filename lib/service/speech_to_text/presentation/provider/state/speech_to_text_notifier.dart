import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:viminsk_assistent/service/speech_action/domain/repositories/speech_action_repository.dart';
import 'package:viminsk_assistent/service/speech_to_text/domain/repositories/speech_to_text_repository.dart';
import 'package:viminsk_assistent/service/speech_to_text/presentation/provider/state/speech_to_text_state.dart';
import 'package:viminsk_assistent/service/text_to_speech/domain/repositories/text_to_speech_repository.dart';

class SpeechToTextNotifier extends StateNotifier<SpeechToTextState> {
  final SpeechToTextRepository speechToTextRepository;
  final SpeechActionRepository speechActionRepository;
  final TextToSpeechRepository textToSpeechRepository;

  SpeechToTextNotifier(
    this.speechToTextRepository,
    this.speechActionRepository,
    this.textToSpeechRepository,
  ) : super(const SpeechToTextState());

  Future<bool> initialize() async {
    if (await _requestMicrophonePermission()) {
      return await speechToTextRepository.initializeOffline();
    }
    return false;
  }

  Future<void> startListeningForCommand() async {
    if (await initialize()) {
      await speechToTextRepository.startOfflineListeningForCall(
        onCallAssistant: () async {
          state = state.copyWith(isListening: true);
          await speechToTextRepository.stopOfflineListening();

          await speechToTextRepository.startOnlineListeningForCommand(
            onSoundLevelChange: (value) =>
                state = state.copyWith(soundLevel: value),
            onOfflineSpeechRecognized: () =>
                state = state.copyWith(isLoading: true),
            onOnlineRecognizingError: () {
              stopListening();
              startListeningForCommand();
            },
            onDone: (command) async {
              await speechToTextRepository.stopOnlineListening();

              if (command.isNotEmpty) {
                final resultString =
                    await speechActionRepository.processCommand(command);

                if (resultString.isNotEmpty) {
                  await textToSpeechRepository.speak(resultString);

                  state = state.copyWith(
                    isLoading: false,
                    speechActionResult: resultString,
                  );
                } else {
                  state = state.copyWith(
                    isLoading: false,
                    //speechActionResult: tempSpeechActionResult,
                  );
                }
              }

              // for test call again
              stopListening();
              startListeningForCommand();
            },
          );
        },
      );
    }
  }

  Future<void> stopListening({bool isForceCancel = false}) async {
    if (isForceCancel) speechActionRepository.cancelProcessCommand();

    state = state.copyWith(
      isListening: false,
      soundLevel: 0.0,
      recognizedWords: "",
    );
  }

  // Future<void> _handleListeningComplete(String tempSpeechActionResult) async {
  //   if (state.recognizedWords.isNotEmpty) {
  //     state = state.copyWith(isLoading: true);

  //     final resultString =
  //         await speechActionRepository.processCommand(state.recognizedWords);

  //     if (resultString.isNotEmpty) {
  //       await textToSpeechRepository.speak(resultString);
  //       state = state.copyWith(
  //         isLoading: false,
  //         speechActionResult: resultString,
  //       );
  //     } else {
  //       state = state.copyWith(
  //         isLoading: false,
  //         speechActionResult: tempSpeechActionResult,
  //       );
  //     }
  //   } else {
  //     state = state.copyWith(speechActionResult: tempSpeechActionResult);
  //   }

  //   await stopListening();
  // }

  // Future<void> stopListening({bool isForceCancel = false}) async {
  //   if (isForceCancel) speechActionRepository.cancelProcessCommand();

  //   await speechToTextRepository.stopListening();
  //   state = state.copyWith(
  //     isListening: false,
  //     soundLevel: 0.0,
  //     recognizedWords: "",
  //   );
  // }

  Future<bool> _requestMicrophonePermission() async {
    return await Permission.microphone.request() != PermissionStatus.denied;
  }
}
