import 'package:flutter/material.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import '../../domain/repositories/overlay_window_repositories.dart';

class OverlayWindowsRepositoriesImpl extends OverlayWindowRepositories {
  @override
  void initialize() async {
    if (!await FlutterOverlayWindow.isPermissionGranted()) {
      await FlutterOverlayWindow.requestPermission();
    }
  }

  @override
  void startOverlay(BuildContext context) async {
    await FlutterOverlayWindow.showOverlay(
      enableDrag: true,
      overlayTitle: "X-SLAYER",
      overlayContent: 'Overlay Enabled',
      flag: OverlayFlag.defaultFlag,
      visibility: NotificationVisibility.visibilityPublic,
      positionGravity: PositionGravity.auto,
      height: 200,
      width: 200,
      startPosition: const OverlayPosition(0, -259),
    );
  }

  @override
  void stopOverlay() async {
    FlutterOverlayWindow.closeOverlay();
  }
}
