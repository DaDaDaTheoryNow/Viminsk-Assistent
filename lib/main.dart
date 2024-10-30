import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:viminsk_assistent/service/observer/data/repositories/observer_data_repositories.dart';
import 'package:viminsk_assistent/service/overlay_window/data/widget/overlay_widget.dart';
import 'package:viminsk_assistent/service/overlay_window/domain/provider/overlay_window_provide.dart';

import 'config/routes/routes_provider.dart';
import 'config/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const ProviderScope(child: MyApp()));
}

@pragma("vm:entry-point")
void overlayMain() {
  runApp(const ProviderScope(child: OverlayWidget()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final route = ref.watch(routesProvider);

    ref.read(overlayWindowRepositoriesProvider).initialize();

    final appLifecycleObserver =
        AppLifecycleObserverRepositories(onStateChange: {
      AppLifecycleState.resumed: () {
        ref.read(overlayWindowRepositoriesProvider).startOverlay(context);
        print('Приложение восстановлено');
      },
      AppLifecycleState.paused: () {
        ref.read(overlayWindowRepositoriesProvider).stopOverlay();
        print('Приложение приостановлено');
      },
    });

    // Добавляем наблюдателя
    WidgetsBinding.instance.addObserver(appLifecycleObserver);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Viminsk Assistance',
      theme: AppTheme.dark,
      routerConfig: route,
    );
  }
}
