import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class OverlayWindowRepositories {
  void initialize();
  void startOverlay(BuildContext context);
  void stopOverlay();
}
