import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:viminsk_assistent/service/observer/data/repositories/observer_data_repositories.dart';
import 'package:viminsk_assistent/service/overlay_window/data/widget/overlay_widget.dart';
import 'package:viminsk_assistent/service/overlay_window/domain/provider/overlay_window_provide.dart';
import 'package:viminsk_assistent/service/speech_to_text/presentation/provider/speech_to_text_notifier_provider.dart';

import 'config/routes/routes_provider.dart';
import 'config/theme/app_theme.dart';

final providerContainer = ProviderContainer();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Method channel for overlay communication
  const platform = MethodChannel('overlay_channel');
  platform.setMethodCallHandler((MethodCall call) async {
    if (call.method == 'startSpeechRecognition') {
      final speechToTextNotifier =
          providerContainer.read(speechToTextNotifierProvider.notifier);
      if (await speechToTextNotifier.initialize()) {
        speechToTextNotifier.startListening();
      }
    }
  });

  // Run the app with the ProviderContainer
  runApp(ProviderScope(
    parent: providerContainer,
    child: MyApp(),
  ));
}

@pragma("vm:entry-point")
void overlayMain() {
  WidgetsFlutterBinding.ensureInitialized();

  // Инициализируем канал здесь для оверлея
  const platform = MethodChannel('overlay_channel');

  runApp(const ProviderScope(child: OverlayWidget()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final route = ref.watch(routesProvider);
    ref.read(overlayWindowRepositoriesProvider).initialize();

    // App lifecycle observer for handling overlay state
    final appLifecycleObserver = AppLifecycleObserverRepositories(
      onStateChange: {
        AppLifecycleState.resumed: () {
          ref.read(overlayWindowRepositoriesProvider).stopOverlay();
          print('Приложение восстановлено');
        },
        AppLifecycleState.paused: () {
          ref.read(overlayWindowRepositoriesProvider).startOverlay(context);
          print('Приложение приостановлено');
        },
      },
    );

    // Adding the observer to the app lifecycle
    WidgetsBinding.instance.addObserver(appLifecycleObserver);

    // Main application widget
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Viminsk Assistance',
      theme: AppTheme.dark,
      routerConfig: route,
    );
  }
}
