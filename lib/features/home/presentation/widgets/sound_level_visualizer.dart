import 'dart:math';
import 'package:flutter/material.dart';

class SoundLevelVisualizer extends StatelessWidget {
  final double soundLevel;

  const SoundLevelVisualizer({super.key, required this.soundLevel});

  @override
  Widget build(BuildContext context) {
    // Increase the impact of the sound level on the heights of the bars
    final heights = List.generate(7, (index) {
      double randomFactor = Random().nextDouble();
      // Amplify the height impact and adjust for more pronounced response
      return ((soundLevel + 10) * 6 * randomFactor)
          .clamp(10, 120); // Increased max height
    });

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(7, (index) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300), // Faster response time
          curve: Curves.easeInOut,
          width: 10,
          height: heights[index].toDouble(),
          margin: const EdgeInsets.symmetric(horizontal: 5),
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(5),
          ),
        );
      }),
    );
  }
}
