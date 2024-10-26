import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/text_speech_repository_impl.dart';
import '../repositories/text_speech_repository.dart';

final textSpeechRepositoryProvider = Provider<TextSpeechRepository>((ref) {
  final repository = TextSpeechRepositoryImpl();
  return repository;
});
