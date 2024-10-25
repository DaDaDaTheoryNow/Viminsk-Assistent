import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'widgets/listening_button.dart';

class HomeScreen extends ConsumerWidget {
  static HomeScreen builder(
    BuildContext context,
    GoRouterState state,
  ) =>
      const HomeScreen();

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        body: Stack(children: [
      Align(
        alignment: Alignment.center,
        child: Text(
          'Готов слушать !',
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      const Align(alignment: Alignment.bottomCenter, child: ListeningButton()),
    ]));
  }
}
