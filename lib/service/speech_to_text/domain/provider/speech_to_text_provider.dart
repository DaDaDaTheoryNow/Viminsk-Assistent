import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:viminsk_assistent/service/speech_to_text/data/datasource/local/speech_to_text_local_datasource_repository.dart';
import 'package:viminsk_assistent/service/speech_to_text/data/datasource/local/speech_to_text_local_datasource.dart';
import 'package:viminsk_assistent/service/speech_to_text/data/datasource/remote/speech_to_text_remote_datasource.dart';
import 'package:viminsk_assistent/service/speech_to_text/data/datasource/remote/speech_to_text_remote_datasource_repository.dart';
import 'package:viminsk_assistent/service/speech_to_text/data/repositories/speech_to_text_repository_impl.dart';
import 'package:viminsk_assistent/service/speech_to_text/domain/repositories/speech_to_text_repository.dart';

final speechToTextLocalDataSourceProvider =
    Provider<SpeechToTextLocalDataSourceRepository>((ref) {
  return SpeechToTextLocalDataSource();
});

final speechToTextRemoteDataSourceProvider =
    Provider<SpeechToTextRemoteDataSourceRepository>((ref) {
  return SpeechToTextRemoteDataSource();
});

final speechToTextRepositoryProvider = Provider<SpeechToTextRepository>((ref) {
  final localDataSource = ref.read(speechToTextLocalDataSourceProvider);
  final remoteDataSource = ref.read(speechToTextRemoteDataSourceProvider);
  final repository =
      SpeechToTextRepositoryImpl(localDataSource, remoteDataSource);

  return repository;
});
