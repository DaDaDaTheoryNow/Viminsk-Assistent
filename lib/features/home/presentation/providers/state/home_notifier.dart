import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:viminsk_assistent/features/home/presentation/providers/state/home_state.dart';

class HomeNotifier extends StateNotifier<HomeState> {
  HomeNotifier() : super(const HomeState());
}
