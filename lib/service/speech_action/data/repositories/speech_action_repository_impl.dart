import 'package:installed_apps/installed_apps.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:viminsk_assistent/service/speech_action/data/datasource/remote/ai_interface_datasource.dart';
import 'package:viminsk_assistent/service/speech_action/domain/models/action_type.dart';
import 'package:viminsk_assistent/service/speech_action/domain/repositories/speech_action_repository.dart';

class SpeechActionRepositoryImpl extends SpeechActionRepository {
  final AIInterfaceDataSource aiInterfaceDataSource;

  SpeechActionRepositoryImpl(this.aiInterfaceDataSource);

  @override
  void cancelProcessCommand() {
    aiInterfaceDataSource.cancelRequest();
  }

  @override
  Future<String> processCommand(String message) async {
    final messageForAnalysis = message.toLowerCase();

    if (messageForAnalysis.contains("загугли") ||
        messageForAnalysis.contains("найди")) {
      _searchInBrowser(messageForAnalysis);
      return "Выполнил поиск";
    }

    final questionType =
        await aiInterfaceDataSource.questionType(question: messageForAnalysis);

    switch (questionType) {
      case ActionType.startApp:
        if (messageForAnalysis.contains("браузер") ||
            messageForAnalysis.contains("chrome") ||
            messageForAnalysis.contains("поисковик")) {
          return _startBrowser();
        }

        final appPackage =
            await aiInterfaceDataSource.startApp(question: messageForAnalysis);

        if (appPackage.isEmpty) return "";

        final bool? isSuccess = await InstalledApps.startApp(appPackage);
        return isSuccess ?? false
            ? "Запустил приложение"
            : "Не смог запустить приложение";
      case ActionType.question:
        return await aiInterfaceDataSource.questionAnswer(
            question: messageForAnalysis);
      default:
        return "Неизвестная команда";
    }
  }

  Future<String> _searchInBrowser(String message) async {
    List<String> wordsToRemove = ["найди"];
    RegExp regExp = RegExp(wordsToRemove.join("|"));
    String result = message.replaceFirst(regExp, '');

    final query = Uri.encodeComponent(result);
    final Uri uri = Uri.parse("https://www.google.com/search?q=$query");

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      return 'Не удалось открыть ссылку';
    }

    return "Вбил в браузер ваш запрос";
  }

  Future<String> _startBrowser() async {
    final Uri uri = Uri.parse("https://www.google.com/search");

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      return 'Не удалось открыть браузер';
    }

    return "Запустил приложение";
  }
}
