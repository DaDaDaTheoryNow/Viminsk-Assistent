import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mesh_gradient/mesh_gradient.dart';
import 'package:viminsk_assistent/features/home/presentation/widgets/loading_widget.dart';
import 'package:viminsk_assistent/features/home/presentation/widgets/sound_level_visualizer.dart';
import 'package:viminsk_assistent/service/speech_to_text/presentation/provider/speech_to_text_notifier_provider.dart';

class HomeScreen extends ConsumerStatefulWidget {
  static HomeScreen builder(
    BuildContext context,
    GoRouterState state,
  ) =>
      const HomeScreen();
  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    ref.read(speechToTextNotifierProvider.notifier).startListeningForCommand();
    //ref.read(backgroundRepositoriesProvider).initializedBackgroundService();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final speechActionResult =
        ref.watch(speechToTextNotifierProvider).speechActionResult;
    final isListening = ref.watch(speechToTextNotifierProvider).isListening;
    final isLoading = ref.watch(speechToTextNotifierProvider).isLoading;
    final soundLevel = ref.watch(speechToTextNotifierProvider).soundLevel;
    final isInitialize = ref.watch(speechToTextNotifierProvider).isInitialize;
    return Scaffold(
      // floatingActionButton: ListeningButton(
      //     onStartRecording: () {
      //       FlutterBackgroundService().invoke("setAsBackground");
      //     },
      //     onStopRecording: () {
      //       FlutterBackgroundService().invoke("stopService");
      //     },
      //     isListening: isListening),
      body: Stack(
        children: [
          AnimatedOpacity(
            opacity: isInitialize ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 1000),
            curve: Curves.easeIn,
            child: Stack(
              children: [
                // bg animation
                AnimatedOpacity(
                  opacity: isListening ? 0.8 : 0.0,
                  duration: const Duration(milliseconds: 1200),
                  curve: Curves.easeIn,
                  child: AnimatedMeshGradient(
                    colors: const [
                      Color.fromARGB(255, 60, 59, 59),
                      Colors.black,
                      Color.fromARGB(255, 111, 109, 109),
                      Colors.black,
                    ],
                    options: AnimatedMeshGradientOptions(
                      amplitude: 2000,
                      frequency: 300,
                      grain: 0.3,
                      speed: 15,
                    ),
                    child: Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                      ),
                    ),
                  ),
                ),

                // content
                Center(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // sound visualizer
                        AnimatedOpacity(
                          opacity: isLoading
                              ? 0.0
                              : isListening
                                  ? 1.0
                                  : 0.0,
                          duration: const Duration(milliseconds: 300),
                          child: Center(
                            child: SoundLevelVisualizer(
                              soundLevel: soundLevel,
                            ),
                          ),
                        ),

                        // result of question
                        AnimatedOpacity(
                          opacity: isLoading
                              ? 0.0
                              : isListening
                                  ? 0.0
                                  : 1.0,
                          duration: const Duration(milliseconds: 250),
                          curve: Curves.easeIn,
                          child: Center(
                            child: Padding(
                              padding: EdgeInsets.all(isListening ? 0 : 30),
                              child: Text(
                                speechActionResult,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: isListening ? 0 : 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // loading
                AnimatedOpacity(
                  opacity: isLoading ? 1.0 : 0.0,
                  duration: Duration(milliseconds: isLoading ? 1000 : 300),
                  child: const LoadingWidget(
                    text: "Думаю...",
                  ),
                ),
              ],
            ),
          ),
          Offstage(
            offstage: isInitialize,
            child: AnimatedOpacity(
              opacity: isInitialize ? 0.0 : 1.0,
              duration: const Duration(milliseconds: 1000),
              curve: Curves.easeOut,
              child: const LoadingWidget(
                text: "Загрузка...",
              ),
            ),
          ),
        ],
      ),
    );
  }
}
