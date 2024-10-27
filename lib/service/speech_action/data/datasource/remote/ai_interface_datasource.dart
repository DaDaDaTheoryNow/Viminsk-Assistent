import 'package:viminsk_assistent/service/speech_action/domain/models/action_type.dart';

abstract class AIInterfaceDataSource {
  Future<String> questionAnswer({
    required String question,
  });

  Future<String> startApp({
    required String question,
  });

  Future<ActionType> questionType({
    required String question,
  });

  void cancelRequest();
}
