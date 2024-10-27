import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:installed_apps/installed_apps.dart';
import 'package:viminsk_assistent/service/speech_action/data/datasource/remote/ai_interface_datasource.dart';
import 'package:viminsk_assistent/service/speech_action/domain/models/action_type.dart';

class AIInterfaceRemoteDataSource implements AIInterfaceDataSource {
  final Dio dio;
  final String apiKey = "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";

  CancelToken _cancelToken = CancelToken();
  List<Map<String, String>> listOfAppsTable = [];

  AIInterfaceRemoteDataSource() : dio = Dio() {
    dio.options.headers['Authorization'] = "Bearer $apiKey";
    dio.options.headers['Content-Type'] = "application/json";
  }

  Future<String> _postRequest(Map<String, dynamic> input) async {
    try {
      final response = await dio.post(
        "https://api-inference.huggingface.co/models/mistralai/Mistral-Nemo-Instruct-2407/v1/chat/completions",
        data: jsonEncode(input),
        cancelToken: _cancelToken,
      );

      if (response.statusCode == 200) {
        return response.data['choices'][0]['message']['content'] ??
            'No content';
      } else {
        throw Exception('Failed to load chat completion: ${response.data}');
      }
    } catch (e) {
      if (CancelToken.isCancel(e as DioException)) {
        Future.delayed(const Duration(milliseconds: 250),
            () => _cancelToken = CancelToken());
        return '';
      } else {
        throw Exception('Error during request: $e');
      }
    }
  }

  @override
  Future<String> questionAnswer({required String question}) async {
    final input = {
      "model": "mistralai/Mistral-Nemo-Instruct-2407",
      "messages": [
        {
          "role": "user",
          "content":
              "'$question'. Context: Пожалуйста, отвечай коротко и ясно. Если задают вопрос о твоем имени или создателе, уточни, что ты — Viminsk, созданный командой из 167-й школы города Минска. Старайся использовать простые и понятные фразы."
        },
      ],
      "max_tokens": 400,
    };

    return await _postRequest(input);
  }

  @override
  Future<String> startApp({required String question}) async {
    if (listOfAppsTable.isEmpty) {
      final listOfApps = await InstalledApps.getInstalledApps();
      listOfAppsTable = listOfApps
          .map((app) => {
                "app_name": app.name.toLowerCase(),
                "package_name": app.packageName,
              })
          .toList();
    }

    final input = {
      "model": "mistralai/Mistral-Nemo-Instruct-2407",
      "messages": [
        {
          "role": "user",
          "content":
              "'$question'. Контекст: Ответом должен быть только один packageName из моего списка, в точности как указано. Ответ должен состоять только из одного packageName без других слов, текста или символов. Список приложений чтобы выбрать: $listOfAppsTable",
        },
      ],
      "max_tokens": 400,
    };

    String answer = await _postRequest(input);
    print(answer);
    return answer.replaceAll(RegExp(r"[\'\'[\]]"), "");
  }

  @override
  Future<ActionType> questionType({required String question}) async {
    final input = {
      "model": "mistralai/Mistral-Nemo-Instruct-2407",
      "messages": [
        {
          "role": "user",
          "content":
              "Ответь одним словом startApp или question на этот вопрос: '$question'",
        },
      ],
      "max_tokens": 300,
    };

    String answer = await _postRequest(input);

    if (answer.contains("startApp") || answer.contains("start")) {
      return ActionType.startApp;
    } else {
      return ActionType.question;
    }
  }

  @override
  void cancelRequest() {
    _cancelToken.cancel("Request canceled by user");
  }
}
