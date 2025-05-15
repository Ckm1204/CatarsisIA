import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/grounding_bloc.dart';
import '../blocs/grounding_event.dart';
import '../blocs/grounding_state.dart';
import '../widgets/breathing_widget.dart';
import '../widgets/grounding_exercise_widget.dart';
import '../widgets/visualization_widget.dart';



class GroundingPage extends StatelessWidget {
  const GroundingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GroundingBloc(),
      child: Scaffold(
        appBar: AppBar(
            automaticallyImplyLeading: false,
            title: const Text("Técnicas de Anclaje")),
        body: BlocBuilder<GroundingBloc, GroundingState>(
          builder: (context, state) {
            if (state is GroundingExerciseInProgress) {
              return const GroundingExerciseWidget();
            } else if (state is BreathingExerciseInProgress) {
              return const BreathingWidget();
            } else if (state is VisualizationInProgress) {
              return const VisualizationWidget();
            }

            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () => context.read<GroundingBloc>().add(StartGroundingExercise()),
                    child: const Text("Ejercicio 5-4-3-2-1"),
                  ),
                  ElevatedButton(
                    onPressed: () => context.read<GroundingBloc>().add(StartBreathingExercise()),
                    child: const Text("Respiración Controlada"),
                  ),
                  ElevatedButton(
                    onPressed: () => context.read<GroundingBloc>().add(StartVisualizationExercise()),
                    child: const Text("Visualización Guiada"),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
