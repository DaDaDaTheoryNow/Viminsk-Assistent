import 'package:viminsk_assistent/service/speech_action/domain/models/action_type.dart';

abstract class AIInterfaceDataSource {
  Future<String> questionAnswer({
    required String question,
  });

  void cancelRequest();

  Future<String> startApp({
    required String question,
    required List<Map<String, String>> mapOfInstalledApps,
  });

  Future<ActionType> questionType({
    required String question,
  });

  Future<String> phoneNumber({required String question, required Map contacts});
}
