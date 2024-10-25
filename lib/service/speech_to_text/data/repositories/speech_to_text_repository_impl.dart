import 'package:viminsk_assistent/service/speech_to_text/data/datasource/local/speech_to_text_local_datasource.dart';
import 'package:viminsk_assistent/service/speech_to_text/domain/repositories/speech_to_text_repository.dart';

class SpeechToTextRepositoryImpl implements SpeechToTextRepository {
  final SpeechToTextLocalDataSource dataSource;

  SpeechToTextRepositoryImpl(this.dataSource);

  @override
  Future<bool> initialize() => dataSource.initialize();

  @override
  Future<void> startListening(Function(String) onResult) =>
      dataSource.startListening(onResult);

  @override
  Future<void> stopListening() => dataSource.stopListening();

  @override
  bool get isListening => dataSource.isListening;
}
