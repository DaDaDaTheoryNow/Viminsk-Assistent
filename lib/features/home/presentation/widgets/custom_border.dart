import 'package:flutter/material.dart';
import 'package:viminsk_assistent/utils/utils.dart';

class CustomBorder extends StatelessWidget {
  final bool isListening;
  const CustomBorder({super.key, required this.isListening});

  @override
  Widget build(BuildContext context) {
    var width = WindowSize(context).width;
    var height = WindowSize(context).height;
    return Stack(
      children: [
        // Верхняя граница
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: AnimatedOpacity(
            opacity: isListening ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 300),
            child: AnimatedContainer(
              width: width,
              height: 4,
              duration: const Duration(milliseconds: 300),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Colors.blue, Colors.purple],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                boxShadow: [
                  BoxShadow(
                      color: Colors.purple.withOpacity(0.3),
                      offset: const Offset(0, 5), // Тень вниз
                      blurRadius: 7,
                      spreadRadius: 1.0),
                ],
              ),
            ),
          ),
        ),
        // Нижняя граница
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: AnimatedOpacity(
            opacity: isListening ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 300),
            child: AnimatedContainer(
              width: width,
              height: 4,
              duration: const Duration(milliseconds: 300),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      color: Colors.purple.withOpacity(0.3),
                      offset: const Offset(0, -5), // Тень вверх
                      blurRadius: 7,
                      spreadRadius: 0.5),
                ],
                gradient: const LinearGradient(
                  colors: [Colors.purple, Colors.blue],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
            ),
          ),
        ),
        // Левая граница
        Positioned(
          top: 0,
          bottom: 0,
          left: 0,
          child: AnimatedOpacity(
            opacity: isListening ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 300),
            child: AnimatedContainer(
              width: 4,
              height: height,
              duration: const Duration(milliseconds: 300),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      color: Colors.purple.withOpacity(0.3),
                      offset: const Offset(5, 0),
                      blurRadius: 7,
                      spreadRadius: 0.5),
                ],
                gradient: const LinearGradient(
                  colors: [Colors.blue, Colors.purple],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
        ),
        // Правая граница
        Positioned(
          top: 0,
          bottom: 0,
          right: 0,
          child: AnimatedOpacity(
            opacity: isListening ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 300),
            child: AnimatedContainer(
              width: 4,
              height: height,
              duration: const Duration(milliseconds: 300),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      color: Colors.purple.withOpacity(0.3),
                      offset: const Offset(-5, 0),
                      blurRadius: 5,
                      spreadRadius: 0.5),
                ],
                gradient: const LinearGradient(
                  colors: [Colors.purple, Colors.blue],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
