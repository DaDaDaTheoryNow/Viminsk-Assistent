import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:viminsk_assistent/service/speech_action/data/repositories/speech_action_repository_impl.dart';
import 'package:viminsk_assistent/service/speech_action/domain/repositories/speech_action_repository.dart';

final speechActionRepositoryProvider = Provider<SpeechActionRepository>((ref) {
  final repository = SpeechActionRepositoryImpl();
  return repository;
});
