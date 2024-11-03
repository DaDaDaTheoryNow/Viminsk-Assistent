import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:record/record.dart';
import 'package:viminsk_assistent/service/speech_to_text/data/datasource/local/speech_to_text_local_datasource_repository.dart';
import 'package:vosk_flutter/vosk_flutter.dart';

class SpeechToTextLocalDataSource
    implements SpeechToTextLocalDataSourceRepository {
  final AudioRecorder _recorder = AudioRecorder();
  late Recognizer _recognizer;

  String _buffer = "";
  int _lastProcessedIndex = 0;

  late StreamSubscription<Uint8List>? startListeningForCallStream;

  @override
  Future<bool> initializeVosk() async {
    final vosk = VoskFlutterPlugin.instance();
    final modelLoader = ModelLoader();
    Model? model;

    try {
      model = await vosk.createModel(await modelLoader
          .loadFromAssets("assets/models/vosk-model-small-ru-0.22.zip"));

      _recognizer = await vosk.createRecognizer(
        model: model,
        sampleRate: 16000,
      );
      return true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  @override
  Future<void> startOfflineListeningForCall({
    required VoidCallback onCallAssistant,
  }) async {
    final stream = await _recorder.startStream(
      const RecordConfig(
        sampleRate: 16000,
        encoder: AudioEncoder.pcm16bits,
        numChannels: 1,
      ),
    );

    startListeningForCallStream = stream.listen((bytes) async {
      if (bytes.isNotEmpty) {
        _recognizer.acceptWaveformBytes(bytes);
        final result = await _recognizer.getPartialResult();

        final stringResult = (jsonDecode(result)["partial"] as String).trim();
        _buffer = stringResult;

        if (_lastProcessedIndex <= _buffer.length) {
          final unprocessedText = _buffer
              .substring(_lastProcessedIndex, _buffer.length)
              .trim()
              .toLowerCase();

          _lastProcessedIndex = _buffer.length;

          if (unprocessedText.contains("гриша")) {
            onCallAssistant();
          }
        } else {
          _lastProcessedIndex = _buffer.length;
        }
      }
    });
  }

  @override
  Future<void> stopOfflineListening() async {
    startListeningForCallStream?.cancel();
    await _recorder.stop();
    _recognizer.reset();
  }
}
