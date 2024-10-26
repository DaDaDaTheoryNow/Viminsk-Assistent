import 'package:installed_apps/installed_apps.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:viminsk_assistent/service/speech_action/domain/repositories/speech_action_repository.dart';

class SpeechActionRepositoryImpl extends SpeechActionRepository {
  String messageForAnalysis = '';
  @override
  Future<String> processCommand(String message) async {
    messageForAnalysis = message.toLowerCase();

    // Карта команд и действий
    final commands = {
      "запусти": _runChrome,
      "старт": _runChrome,
      "запуск": _runChrome,
      "перезапусти": _runChrome,
      "google": _runChrome,
      "chrome": _runChrome,
      "telegram": _runTg,
      "gmail": _runMail,
      "почту": _runMail,
      "найди": _searchInBrowser,
    };

    // Поиск подходящей команды
    for (var entry in commands.entries) {
      if (messageForAnalysis.contains(entry.key)) {
        return await entry.value();
      }
    }
    return "Неизвестная команда";
  }

// Функции действий
  Future<String> _runChrome() async {
    await InstalledApps.startApp("com.android.chrome");
    return "Открыл Chrome";
  }

  Future<String> _runTg() async {
    await InstalledApps.startApp("org.telegram.messenger");
    return "Открыл Telegram";
  }

  Future<String> _runMail() async {
    await InstalledApps.startApp("com.google.android.gm");
    return "Открыл почту";
  }

  Future<String> _searchInBrowser() async {
    // Создаем список слов, которые нужно удалить
    List<String> wordsToRemove = ["найди"];

    // Создаем регулярное выражение, которое найдет любое из слов из списка
    RegExp regExp = RegExp(wordsToRemove.join("|"));

    String result = messageForAnalysis.replaceFirst(regExp, '');

    final query = Uri.encodeComponent(result);
    final Uri uri = Uri.parse("https://www.google.com/search?q=$query");

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      return 'Не удалось открыть ссылку';
    }

    return "Вбил в браузер ваш запрос";
  }
}
