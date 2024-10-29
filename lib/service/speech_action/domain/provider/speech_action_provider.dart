import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:viminsk_assistent/service/speech_action/data/datasource/remote/ai_interface_datasource.dart';
import 'package:viminsk_assistent/service/speech_action/data/datasource/remote/ai_interface_remote_datasource.dart';
import 'package:viminsk_assistent/service/speech_action/data/repositories/speech_action_repository_impl.dart';
import 'package:viminsk_assistent/service/speech_action/domain/repositories/speech_action_repository.dart';

final aiInterfaceDataSourceProvider = Provider<AIInterfaceDataSource>((ref) {
  return AIInterfaceRemoteDataSource();
});

final speechActionRepositoryProvider = Provider<SpeechActionRepository>((ref) {
  final aiInterfaceDataSource = ref.read(aiInterfaceDataSourceProvider);
  final repository = SpeechActionRepositoryImpl(aiInterfaceDataSource);
  return repository;
});
