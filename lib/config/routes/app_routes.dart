import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:viminsk_assistent/features/home/presentation/home_screen.dart';

@immutable
class AppRoutes {
  static const home = "/";
  static final appRoutes = [
    GoRoute(
      path: home,
      builder: HomeScreen.builder,
    ),
  ];
}
