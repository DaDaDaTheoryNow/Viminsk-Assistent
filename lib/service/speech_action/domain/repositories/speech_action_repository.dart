abstract class SpeechActionRepository {
  Future<void> initializeInstalledApps();
  Future<String> processCommand(String message);
  void cancelProcessCommand();
}
