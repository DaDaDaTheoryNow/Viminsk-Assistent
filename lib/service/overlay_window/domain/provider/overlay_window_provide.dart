import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:viminsk_assistent/service/overlay_window/data/repositories/overlay_windows_repositories_impl.dart';
import 'package:viminsk_assistent/service/overlay_window/domain/repositories/overlay_window_repositories.dart';

final overlayWindowRepositoriesProvider =
    Provider<OverlayWindowRepositories>((ref) {
  final repository = OverlayWindowsRepositoriesImpl();
  return repository;
});
