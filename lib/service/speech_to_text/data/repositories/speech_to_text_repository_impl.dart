import 'package:flutter/material.dart';
import 'package:viminsk_assistent/service/speech_to_text/data/datasource/local/speech_to_text_local_datasource_repository.dart';
import 'package:viminsk_assistent/service/speech_to_text/data/datasource/remote/speech_to_text_remote_datasource_repository.dart';
import 'package:viminsk_assistent/service/speech_to_text/domain/repositories/speech_to_text_repository.dart';

class SpeechToTextRepositoryImpl implements SpeechToTextRepository {
  final SpeechToTextLocalDataSourceRepository localDataSource;
  final SpeechToTextRemoteDataSourceRepository remoteDataSource;

  SpeechToTextRepositoryImpl(this.localDataSource, this.remoteDataSource);

  @override
  Future<bool> initializeOffline() => localDataSource.initializeVosk();

  @override
  Future<void> startOfflineListeningForCall({
    required VoidCallback onCallAssistant,
  }) =>
      localDataSource.startOfflineListeningForCall(
          onCallAssistant: onCallAssistant);

  @override
  Future<void> stopOfflineListening() => localDataSource.stopOfflineListening();

  @override
  Future<void> startOnlineListeningForCommand({
    required Function(double) onSoundLevelChange,
    required VoidCallback onOfflineSpeechRecognized,
    required VoidCallback onOnlineRecognizingError,
    required Function(String) onDone,
  }) =>
      remoteDataSource.startOnlineListeningForCommand(
        onSoundLevelChange: onSoundLevelChange,
        onOfflineSpeechRecognized: onOfflineSpeechRecognized,
        onOnlineRecognizingError: onOnlineRecognizingError,
        onDone: onDone,
      );

  @override
  Future<void> stopOnlineListening() => remoteDataSource.stopOnlineListening();
}
