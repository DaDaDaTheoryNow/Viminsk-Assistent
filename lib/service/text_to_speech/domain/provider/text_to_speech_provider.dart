import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:viminsk_assistent/service/text_to_speech/data/repositories/text_to_speech_repository_impl.dart';
import 'package:viminsk_assistent/service/text_to_speech/domain/repositories/text_to_speech_repository.dart';

final textToSpeechRepositoryProvider = Provider<TextToSpeechRepository>((ref) {
  final repository = TextToSpeechRepositoryImpl();
  return repository;
});
