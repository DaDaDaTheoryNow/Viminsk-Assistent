import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:viminsk_assistent/features/home/presentation/providers/state/home_notifier.dart';
import 'package:viminsk_assistent/features/home/presentation/providers/state/home_state.dart';

final homeProvider = StateNotifierProvider<HomeNotifier, HomeState>((ref) {
  return HomeNotifier();
});
