import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:viminsk_assistent/service/speech_action/domain/provider/speech_action_provider.dart';
import 'package:viminsk_assistent/service/speech_to_text/domain/provider/speech_to_text_provider.dart';
import 'package:viminsk_assistent/service/text_to_speech/domain/provider/text_to_speech_provider.dart';

import 'state/speech_to_text_state.dart';
import 'state/speech_to_text_notifier.dart';

final speechToTextNotifierProvider =
    StateNotifierProvider<SpeechToTextNotifier, SpeechToTextState>((ref) {
  final speechToTextRepository = ref.read(speechToTextRepositoryProvider);
  final speechActionRepository = ref.read(speechActionRepositoryProvider);
  final textSpeechRepository = ref.read(textToSpeechRepositoryProvider);
  return SpeechToTextNotifier(
      speechToTextRepository, speechActionRepository, textSpeechRepository);
});
