import 'package:installed_apps/installed_apps.dart';
import 'package:viminsk_assistent/service/speech_action/domain/repositories/speech_action_repository.dart';

class SpeechActionRepositoryImpl extends SpeechActionRepository {
  @override
  Future<String> processCommand(String message) async {
    final messageForAnalysis = message.toLowerCase();
    final bool isRunAction = (messageForAnalysis.contains("запусти") ||
        messageForAnalysis.contains("старт") ||
        messageForAnalysis.contains("запуск"));

    if (isRunAction) {
      InstalledApps.startApp("com.android.chrome");
      return "Запускаю Chrome";
    } else {
      return "Неизвестная команда";
    }
  }
}
