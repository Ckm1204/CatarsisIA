import 'package:flutter/material.dart';

class VisualizationWidget extends StatelessWidget {
  const VisualizationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: const [
        Text("Visualiza un lugar tranquilo"),
        Text("Cierra los ojos, respira y escucha los sonidos"),
        Text("Imagina el mar, bosque o un lugar seguro para ti."),
        Icon(Icons.self_improvement, size: 100, color: Colors.blueAccent),
      ],
    );
  }
}
