import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:window_manager/window_manager.dart';

import 'config/routes/routes_provider.dart';
import 'config/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isWindows || Platform.isLinux) {
    await windowManager.ensureInitialized();
    WindowOptions windowOptions = const WindowOptions(
      size: Size(800, 600),
      center: true,
    );
    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });
  }

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final route = ref.watch(routesProvider);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Viminsk Assistance',
      theme: AppTheme.dark,
      routerConfig: route,
    );
  }
}

// import 'dart:convert';
// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:record/record.dart';
// import 'package:vosk_flutter/vosk_flutter.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//       home: VoskFlutterDemo(),
//     );
//   }
// }

// class VoskFlutterDemo extends StatefulWidget {
//   const VoskFlutterDemo({super.key});

//   @override
//   State<VoskFlutterDemo> createState() => _VoskFlutterDemoState();
// }

// class _VoskFlutterDemoState extends State<VoskFlutterDemo> {
//   static const _textStyle = TextStyle(fontSize: 30, color: Colors.black);
//   static const _sampleRate = 16000;

//   final _vosk = VoskFlutterPlugin.instance();
//   final _modelLoader = ModelLoader();
//   final _recorder = AudioRecorder();

//   String? _fileRecognitionResult;
//   String? _error;
//   Model? _model;
//   Recognizer? _recognizer;
//   SpeechService? _speechService;

//   bool _recognitionStarted = false;

//   @override
//   void initState() {
//     super.initState();
//     init();
//   }

//   @override
//   void dispose() {
//     _speechService?.dispose();
//     print("sd");
//     super.dispose();
//   }

//   void init() async {
//     await _speechService?.dispose();
//     Future.microtask(() async => _vosk
//             .createModel(await _modelLoader
//                 .loadFromAssets("assets/models/vosk-model-small-ru-0.22.zip"))
//             .then((model) => setState(() => _model = model))
//             .then((_) => _vosk.createRecognizer(
//                 model: _model!, sampleRate: _sampleRate)) // create recognizer
//             .then((value) => _recognizer = value)
//             .then((recognizer) {
//           if (Platform.isAndroid) {
//             _vosk
//                 .initSpeechService(_recognizer!) // init speech service
//                 .then((speechService) =>
//                     setState(() => _speechService = speechService))
//                 .catchError((e) => setState(() => _error = e.toString()));
//           }
//         }).catchError((e) {
//           setState(() => _error = e.toString());
//           return null;
//         }));
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (_error != null) {
//       return Scaffold(
//           body: Center(child: Text("Error: $_error", style: _textStyle)));
//     } else if (_model == null) {
//       return const Scaffold(
//           body: Center(child: Text("Loading model...", style: _textStyle)));
//     } else if (Platform.isAndroid && _speechService == null) {
//       return const Scaffold(
//         body: Center(
//           child: Text("Initializing speech service...", style: _textStyle),
//         ),
//       );
//     } else {
//       return Platform.isAndroid ? _androidExample() : _commonExample();
//     }
//   }

//   Widget _androidExample() {
//     return Scaffold(
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             ElevatedButton(
//                 onPressed: () async {
//                   if (_recognitionStarted) {
//                     await _speechService!.stop();
//                   } else {
//                     await _speechService!.start();
//                   }
//                   setState(() => _recognitionStarted = !_recognitionStarted);
//                 },
//                 child: Text(_recognitionStarted
//                     ? "Stop recognition"
//                     : "Start recognition")),
//             StreamBuilder(
//                 stream: _speechService!.onPartial(),
//                 builder: (context, snapshot) => Text(
//                     "Partial result: ${snapshot.data.toString()}",
//                     style: _textStyle)),
//             StreamBuilder(
//                 stream: _speechService!.onResult(),
//                 builder: (context, snapshot) => Text(
//                     "Result: ${snapshot.data.toString()}",
//                     style: _textStyle)),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _commonExample() {
//     return Scaffold(
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             ElevatedButton(
//                 onPressed: () async {
//                   if (_recognitionStarted) {
//                     await _stopRecording();
//                   } else {
//                     await _recordAudio();
//                   }
//                   setState(() => _recognitionStarted = !_recognitionStarted);
//                 },
//                 child: Text(
//                     _recognitionStarted ? "Stop recording" : "Record audio")),
//             Text("Final recognition result: $_fileRecognitionResult",
//                 style: _textStyle),
//           ],
//         ),
//       ),
//     );
//   }

//   Future<void> _recordAudio() async {
//     try {
//       final stream = await _recorder.startStream(
//         const RecordConfig(
//           sampleRate: 16000,
//           encoder: AudioEncoder.pcm16bits,
//           numChannels: 1,
//         ),
//       );

//       stream.listen((bytes) async {
//         if (bytes.isNotEmpty) {
//           // Send bytes to Vosk recognizer
//           _recognizer!.acceptWaveformBytes(bytes);
//           final result = await _recognizer!.getPartialResult();

//           if (result.contains("стоп")) {
//             _stopRecording();
//             _recognizer?.reset();
//           }

//           print(result);
//         }
//       });
//     } catch (e) {
//       _error = e.toString() +
//           '\n\n Make sure fmedia(https://stsaz.github.io/fmedia/)'
//               ' is installed on Linux';
//     }
//   }

//   Future<void> _stopRecording() async {
//     try {
//       final filePath = await _recorder.stop();
//       if (filePath != null) {
//         final bytes = File(filePath).readAsBytesSync();
//         _recognizer!.acceptWaveformBytes(bytes);
//         print(await _recognizer!.getFinalResult());
//         _fileRecognitionResult = await _recognizer!.getFinalResult();
//       }
//     } catch (e) {
//       _error = e.toString() +
//           '\n\n Make sure fmedia(https://stsaz.github.io/fmedia/)'
//               ' is installed on Linux';
//     }
//   }
// }
