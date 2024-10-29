abstract class SpeechActionRepository {
  Future<String> processCommand(String message);
  void cancelProcessCommand();
}
