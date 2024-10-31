abstract class AIInterfaceDataSource {
  Future<String> questionAnswer({
    required String question,
  });

  void cancelRequest();

  // Future<String> startApp({
  //   required String question,
  // });

  // Future<ActionType> questionType({
  //   required String question,
  // });
}
