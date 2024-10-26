abstract class TextSpeechRepository {
  Future<void> speak(String text);
  Future<void> stop();
}
