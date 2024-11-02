import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:viminsk_assistent/service/speech_action/domain/models/action_type.dart';

import 'speech_action_repository_impl.dart';

extension WindowsSpeechAction on SpeechActionRepositoryImpl {
  Future<String> processWindowsCommand(String query) async {
    print(query);
    print(query.contains("найди"));
    if (query.contains("гугли") || query.contains("найди")) {
      return await _searchInBrowser(query);
    }

    final actionType =
        await aiInterfaceDataSource.questionType(question: query);

    debugPrint("Тип команды: $actionType");

    if (actionType == ActionType.question) {
      return await aiInterfaceDataSource.questionAnswer(question: query);
    }

    return "Команда не поддерживается на Winodws";
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
}
