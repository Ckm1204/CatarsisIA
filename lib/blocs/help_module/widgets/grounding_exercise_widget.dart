import 'package:flutter/material.dart';

class GroundingExerciseWidget extends StatelessWidget {
  const GroundingExerciseWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: const [
        Text("5 cosas que puedes ver:"),
        Text("4 cosas que puedes tocar:"),
        Text("3 cosas que puedes oír:"),
        Text("2 cosas que puedes oler:"),
        Text("1 cosa que puedes saborear:"),
        Divider(),
        Text("Describe un objeto cercano con detalle:"),
      ],
    );
  }
}
