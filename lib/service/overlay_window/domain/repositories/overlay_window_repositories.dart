import 'package:flutter/material.dart';

abstract class OverlayWindowRepositories {
  void initialize();
  void startOverlay(BuildContext context);
  void stopOverlay();
}
