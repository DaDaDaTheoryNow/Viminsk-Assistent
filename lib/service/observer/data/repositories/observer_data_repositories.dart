import 'package:flutter/material.dart';

class AppLifecycleObserverRepositories extends WidgetsBindingObserver {
  final Map<AppLifecycleState, void Function()> onStateChange;

  AppLifecycleObserverRepositories({
    required this.onStateChange,
  });

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    final handler = onStateChange[state];
    if (handler != null) {
      handler();
    }
  }
}
