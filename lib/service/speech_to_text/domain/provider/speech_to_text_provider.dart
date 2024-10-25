import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:viminsk_assistent/service/speech_to_text/data/datasource/local/speech_to_text_local_datasource.dart';
import 'package:viminsk_assistent/service/speech_to_text/data/datasource/local/speech_to_text_local_datasource_impl.dart';
import 'package:viminsk_assistent/service/speech_to_text/data/repositories/speech_to_text_repository_impl.dart';
import 'package:viminsk_assistent/service/speech_to_text/domain/repositories/speech_to_text_repository.dart';

final speechToTextDataSourceProvider =
    Provider<SpeechToTextLocalDataSource>((ref) {
  return SpeechToTextLocalDataSourceImpl();
});

final speechToTextRepositoryProvider = Provider<SpeechToTextRepository>((ref) {
  final datasource = ref.watch(speechToTextDataSourceProvider);
  final repository = SpeechToTextRepositoryImpl(datasource);

  return repository;
});
