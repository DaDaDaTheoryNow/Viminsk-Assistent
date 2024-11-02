import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/services.dart';
import 'package:installed_apps/installed_apps.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
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
    print(questionType);
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
      case ActionType.call:
        return _call(messageForAnalysis);
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

  Future<String> _call(String question) async {
    final String phone = await aiInterfaceDataSource.phoneNumber(
        question: question, contacts: await getContacts());
    makePhoneCall(phone);
    return "Сделал звонок";
  }

  Future<Map<String, String>> getContacts() async {
    var status = await Permission.contacts.status;
    if (!status.isGranted) {
      status = await Permission.contacts.request();
    }

    if (status.isGranted) {
      Iterable<Contact> contacts = await ContactsService.getContacts();
      Map<String, String> contactsMap = {};
      for (var contact in contacts) {
        if (contact.phones!.isNotEmpty) {
          contactsMap[contact.displayName ?? 'Без имени'] =
              contact.phones!.first.value ?? '';
        }
      }
      return contactsMap;
    } else {
      throw 'Разрешение на доступ к контактам не получено';
    }
  }

  Future<void> makePhoneCall(String phoneNumber) async {
    const platform = MethodChannel('com.example.call_channel');
    try {
      await platform.invokeMethod('makeCall', {'phoneNumber': phoneNumber});
    } on PlatformException catch (e) {
      print("Ошибка при вызове звонка: ${e.message}");
    }
  }
}
