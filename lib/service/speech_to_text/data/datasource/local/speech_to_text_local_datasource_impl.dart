import 'package:speech_to_text/speech_to_text.dart';
import 'package:viminsk_assistent/service/speech_to_text/data/datasource/local/speech_to_text_local_datasource.dart';

class SpeechToTextLocalDataSourceImpl implements SpeechToTextLocalDataSource {
  final SpeechToText _speechToText = SpeechToText();

  @override
  Future<bool> initialize() async {
    return await _speechToText.initialize();
  }

  @override
  Future<void> startListening(Function(String) onResult) async {
    final options = SpeechListenOptions(
      partialResults: false,
    );

    await _speechToText.listen(
      localeId: "ru_Ru",
      listenOptions: options,
      onResult: (result) {
        onResult(result.recognizedWords);
      },
    );
  }

  @override
  Future<void> stopListening() async {
    await _speechToText.stop();
  }

  @override
  bool get isListening => _speechToText.isListening;
}
