abstract class SpeechToTextRepository {
  Future<bool> initialize();
  Future<void> startListening(Function(String) onResult);
  Future<void> stopListening();
  bool get isListening;
}
