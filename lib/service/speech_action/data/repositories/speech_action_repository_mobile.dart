import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:installed_apps/installed_apps.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:viminsk_assistent/service/speech_action/domain/models/action_type.dart';

import 'speech_action_repository_impl.dart';

extension MobileSpeechAction on SpeechActionRepositoryImpl {
  Future<String> processMobileCommand(String query) async {
    if (query.contains("гугли") || query.contains("найди")) {
      return await _searchInBrowser(query);
    }

    final actionType =
        await aiInterfaceDataSource.questionType(question: query);

    debugPrint("Тип команды: $actionType");

    switch (actionType) {
      case ActionType.startApp:
        return await _handleAppStart(query);
      case ActionType.call:
        return await _makeCall(query);
      case ActionType.question:
        return await aiInterfaceDataSource.questionAnswer(question: query);
      default:
        return "Неизвестная команда";
    }
  }

  Future<String> _searchInBrowser(String message) async {
    final cleanedMessage =
        message.replaceFirst(RegExp("найди|загугли|за гугли|гугли"), '');
    final encodedQuery = Uri.encodeComponent(cleanedMessage);
    final url = Uri.parse("https://www.google.com/search?q=$encodedQuery");

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
      return "Поиск выполнен";
    }
    return 'Не удалось выполнить поиск';
  }

  Future<String> _handleAppStart(String query) async {
    if (query.contains("браузер") ||
        query.contains("chrome") ||
        query.contains("поисковик")) {
      return await _openBrowser();
    }

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

    if (phone.isNotEmpty) {
      _initiatePhoneCall(phone);
      return "Звонок выполнен";
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
