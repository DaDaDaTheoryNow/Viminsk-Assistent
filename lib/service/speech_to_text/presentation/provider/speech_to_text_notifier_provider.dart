import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:viminsk_assistent/service/speech_to_text/domain/provider/speech_to_text_provider.dart';

import 'state/speech_to_text_notifier.dart';

final speechToTextNotifierProvider =
    StateNotifierProvider<SpeechToTextNotifier, bool>((ref) {
  final repository = ref.watch(speechToTextRepositoryProvider);
  return SpeechToTextNotifier(repository);
});
