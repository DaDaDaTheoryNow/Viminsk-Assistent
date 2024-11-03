import 'dart:async';
import 'dart:ui';

import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:viminsk_assistent/service/background/domain/repositories/background_repositories.dart';

class BackgroundRepositoriesImpl extends BackgroundRepositories {
  @override
  Future<void> initializedBackgroundService() async {
    final service = FlutterBackgroundService();
    await service.configure(
      iosConfiguration: IosConfiguration(),
      androidConfiguration: AndroidConfiguration(
        onStart: onStart,
        isForegroundMode: true,
        autoStart: true,
      ),
    );
  }
}

@pragma("vm:entry-point")
void onStart(ServiceInstance service) async {
  DartPluginRegistrant.ensureInitialized();
  if (service is AndroidServiceInstance) {
    service.on('setAsForeground').listen((event) {
      service.setAsForegroundService();
    });
    service.on('setAsBackground').listen((event) {
      service.setAsBackgroundService();
    });
    service.on('stopService').listen((event) {
      service.stopSelf();
    });
    Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (await service.isForegroundService()) {
        service.setForegroundNotificationInfo(
          title: "script academy",
          content: "hola",
        );
      }
      print("background service running");
      service.invoke("update");
    });
  }
}
