import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:installed_apps/installed_apps.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:viminsk_assistent/service/speech_action/data/datasource/remote/ai_interface_datasource.dart';
import 'package:viminsk_assistent/service/speech_action/domain/models/action_type.dart';
import 'package:viminsk_assistent/service/speech_action/domain/repositories/speech_action_repository.dart';

class SpeechActionRepositoryImpl extends SpeechActionRepository {
  final AIInterfaceDataSource aiInterfaceDataSource;

  SpeechActionRepositoryImpl(this.aiInterfaceDataSource);

  List<Map<String, String>> mapOfInstalledApps = [];

  @override
  Future<void> initializeInstalledApps() async {
    if (mapOfInstalledApps.isEmpty) {
      final listOfInstalledApps = await InstalledApps.getInstalledApps();
      mapOfInstalledApps = listOfInstalledApps
          .map((app) => {
                "app_name": app.name.toLowerCase(),
                "package_name": app.packageName,
              })
          .toList();
    }

    return;
  }

  @override
  void cancelProcessCommand() {
    aiInterfaceDataSource.cancelRequest();
  }

  @override
  Future<String> processCommand(String message) async {
    final query = message.toLowerCase();

    if (query.contains("загугли") ||
        query.contains("найди") ||
        query.contains("за гугли")) {
      return await _searchInBrowser(query);
    }

    final actionType =
        await aiInterfaceDataSource.questionType(question: query);

    debugPrint("Тип команды: $actionType");

    switch (actionType) {
      case ActionType.startApp:
        return await _handleAppStart(query);
      case ActionType.question:
        return await aiInterfaceDataSource.questionAnswer(question: query);
      case ActionType.call:
        return await _makeCall(query);
      default:
        return "Неизвестная команда";
    }
  }

  Future<String> _searchInBrowser(String message) async {
    final cleanedMessage = message.replaceFirst(RegExp("найди"), '');
    final encodedQuery = Uri.encodeComponent(cleanedMessage);
    final url = Uri.parse("https://www.google.com/search?q=$encodedQuery");

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
      return "Поиск выполнен";
    }
    return 'Не удалось выполнить поиск';
  }

  Future<String> _handleAppStart(String query) async {
    // Check for specific apps directly
    if (query.contains("браузер") ||
        query.contains("chrome") ||
        query.contains("поисковик")) {
      return await _openBrowser();
    }

    // App launch by package name
    final appPackage = await aiInterfaceDataSource.startApp(
      question: query,
      mapOfInstalledApps: mapOfInstalledApps,
    );

    if (appPackage.isEmpty) return "Приложение не найдено";

    final success = await InstalledApps.startApp(appPackage) ?? false;
    return success ? "Приложение запущено" : "Ошибка при запуске приложения";
  }

  Future<String> _openBrowser() async {
    final url = Uri.parse("https://www.google.com");
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
      return "Браузер открыт";
    }
    return 'Не удалось открыть браузер';
  }

  Future<String> _makeCall(String query) async {
    final contacts = await _fetchContacts();
    final phone = await aiInterfaceDataSource.phoneNumber(
      question: query,
      contacts: contacts,
    );

    debugPrint(phone);

    if (phone.isNotEmpty) {
      _initiatePhoneCall(phone);
      return "Звонок совершен";
    }
    return "Контакт не найден";
  }

  Future<Map<String, String>> _fetchContacts() async {
    var permissionStatus = await Permission.contacts.status;
    if (!permissionStatus.isGranted) {
      permissionStatus = await Permission.contacts.request();
    }

    if (permissionStatus.isGranted) {
      final contacts = await ContactsService.getContacts();
      return {
        for (var contact in contacts)
          if (contact.phones!.isNotEmpty)
            contact.displayName ?? 'Без имени':
                contact.phones!.first.value ?? ''
      };
    } else {
      throw 'Отказано в доступе к контактам';
    }
  }

  void _initiatePhoneCall(String phoneNumber) async {
    const channel = MethodChannel('com.example.call_channel');
    try {
      channel.invokeMethod('makeCall', {'phoneNumber': phoneNumber});
    } on PlatformException catch (e) {
      debugPrint("Ошибка при совершении звонка: ${e.message}");
    }
  }
}
