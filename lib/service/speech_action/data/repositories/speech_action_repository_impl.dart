import 'package:url_launcher/url_launcher.dart';
import 'package:viminsk_assistent/service/speech_action/data/datasource/remote/ai_interface_datasource.dart';
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
        messageForAnalysis.contains("найди") ||
        messageForAnalysis.contains("за гугли")) {
      _searchInBrowser(messageForAnalysis);
      return "Выполнил поиск";
    }

    return await aiInterfaceDataSource.questionAnswer(
        question: messageForAnalysis);
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

  // Future<String> _startBrowser() async {
  //   final Uri uri = Uri.parse("https://www.google.com/search");

  //   if (await canLaunchUrl(uri)) {
  //     await launchUrl(uri, mode: LaunchMode.externalApplication);
  //   } else {
  //     return 'Не удалось открыть браузер';
  //   }

  //   return "Запустил приложение";
  // }
}
