import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:viminsk_assistent/config/contants.dart';

import 'speech_to_text_remote_datasource_repository.dart';

class SpeechToTextRemoteDataSource
    implements SpeechToTextRemoteDataSourceRepository {
  final Dio dio;

  SpeechToTextRemoteDataSource() : dio = Dio() {
    dio.options.headers['Authorization'] = "Bearer $kApiKey";
    (Platform.isWindows)
        ? dio.options.headers['Content-Type'] = "audio/wav"
        : dio.options.headers['Content-Type'] = "audio/mp3";
  }

  final AudioRecorder _recorder = AudioRecorder();
  Timer? _silenceTimer;
  final double amplitudeThreshold = 6;
  final Duration silenceDuration =
      const Duration(seconds: 1, milliseconds: 700);

  late StreamSubscription<Amplitude>? startListeningForCommandStream;

  @override
  Future<void> startOnlineListeningForCommand({
    required Function(double) onSoundLevelChange,
    required VoidCallback onOfflineSpeechRecognized,
    required VoidCallback onOnlineRecognizingError,
    required Function(String) onDone,
  }) async {
    final directory = await getTemporaryDirectory();

    final filePath = (Platform.isWindows)
        ? '${directory.path}/temp_audio.wav'
        : '${directory.path}/temp_audio.mp3';

    await _recorder.start(
      (Platform.isWindows)
          ? const RecordConfig(
              encoder: AudioEncoder.pcm16bits,
            )
          : const RecordConfig(),
      path: filePath,
    );

    _resetSilenceTimer(
        onDone, onOfflineSpeechRecognized, onOnlineRecognizingError);

    startListeningForCommandStream =
        _recorder.onAmplitudeChanged(Durations.medium4).listen((amplitude) {
      double normalizedValue = ((amplitude.current + 160) / 160) * 20 - 10;
      onSoundLevelChange(normalizedValue);

      if (normalizedValue > amplitudeThreshold) {
        _resetSilenceTimer(
            onDone, onOfflineSpeechRecognized, onOnlineRecognizingError);
      }
    });
  }

  @override
  Future<void> stopOnlineListening() async {
    startListeningForCommandStream?.cancel();
    _silenceTimer?.cancel();
  }

  void _resetSilenceTimer(
    Function(String) onDone,
    VoidCallback onOfflineSpeechRecognized,
    VoidCallback onOnlineRecognizingError,
  ) {
    _silenceTimer?.cancel();

    _silenceTimer = Timer(silenceDuration, () async {
      onOfflineSpeechRecognized();

      final pathToFile = await _recorder.stop();

      if (pathToFile != null) {
        try {
          final file = File(pathToFile);
          final bytes = await file.readAsBytes();

          final response = await dio.post(
            'https://api-inference.huggingface.co/models/openai/whisper-large-v3-turbo',
            data: bytes,
          );

          onDone((response.data["text"] as String).trim().replaceAll(".", ""));
        } catch (e) {
          debugPrint(e.toString());
          onOnlineRecognizingError();
        }
      }
    });
  }
}
