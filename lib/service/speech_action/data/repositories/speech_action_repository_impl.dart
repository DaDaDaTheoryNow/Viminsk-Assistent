import 'dart:io' show Platform;
import 'package:installed_apps/installed_apps.dart';
import 'package:viminsk_assistent/service/speech_action/data/datasource/remote/ai_interface_datasource.dart';

import 'package:viminsk_assistent/service/speech_action/domain/repositories/speech_action_repository.dart';
import 'speech_action_repository_windows.dart';
import 'speech_action_repository_mobile.dart';

class SpeechActionRepositoryImpl extends SpeechActionRepository {
  final AIInterfaceDataSource aiInterfaceDataSource;

  SpeechActionRepositoryImpl(this.aiInterfaceDataSource);

  // Initialize apps (for mobile only)
  List<Map<String, String>> mapOfInstalledApps = [];

  @override
  Future<void> initializeInstalledApps() async {
    if (Platform.isAndroid) {
      // Android-only initialization
      if (mapOfInstalledApps.isEmpty) {
        final listOfInstalledApps = await InstalledApps.getInstalledApps();
        mapOfInstalledApps = listOfInstalledApps
            .map((app) => {
                  "app_name": app.name.toLowerCase(),
                  "package_name": app.packageName,
                })
            .toList();
      }
    }
  }

  @override
  Future<String> processCommand(String message) async {
    final trimLowerCaseMessage = message.trim().toLowerCase();

    if (Platform.isAndroid) {
      return await processMobileCommand(trimLowerCaseMessage);
    } else if (Platform.isWindows) {
      return await processWindowsCommand(trimLowerCaseMessage);
    }
    return "Unsupported platform";
  }

  @override
  void cancelProcessCommand() {
    aiInterfaceDataSource.cancelRequest();
  }
}
