import 'package:flutter/material.dart';

class BreathingWidget extends StatelessWidget {
  const BreathingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          "Respiración 4-7-8:",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 24),
        Image.asset(
          'assets/images/on_boarding_images/respiracion 474.gif',
          height: 320,
          fit: BoxFit.contain,
        ),
        const SizedBox(height: 16),
        const Text(
          "Inhala por 4 segundos",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20),
        ),
        const SizedBox(height: 8),
        const Text(
          "Mantén por 7 segundos",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20),
        ),
        const SizedBox(height: 8),
        const Text(
          "Exhala por 8 segundos",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20),
        ),
      ],
    );
  }
}