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
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pushReplacementNamed('/home'),
          ),
          automaticallyImplyLeading: false,
          title: const Text(
            "Técnicas de Anclaje",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
              color: Colors.white,
            ),
          ),

          centerTitle: true,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.blue.shade700,
                  Colors.teal.shade400,
                ],
              ),
            ),
          ),
          elevation: 10,
          shadowColor: Colors.blue.shade200,


        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.blue.shade50,
                Colors.teal.shade50,
              ],
            ),
          ),
          child: BlocBuilder<GroundingBloc, GroundingState>(
            builder: (context, state) {
              if (state is GroundingExerciseInProgress) {
                return const GroundingExerciseWidget();
              } else if (state is BreathingExerciseInProgress) {
                return const BreathingWidget();
              } else if (state is VisualizationInProgress) {
                return const VisualizationWidget();
              }

              return Center(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Elige una técnica de relajación",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueGrey,
                          ),
                        ),
                        const SizedBox(height: 30),
                        _buildExerciseCard(
                          context,
                          "Ejercicio 5-4-3-2-1",
                          "Conecta con tus sentidos para reducir la ansiedad",
                          Icons.visibility,
                          Colors.indigo,
                              () => context.read<GroundingBloc>().add(StartGroundingExercise()),
                        ),
                        const SizedBox(height: 20),
                        _buildExerciseCard(
                          context,
                          "Respiración Controlada",
                          "Regula tu respiración para calmar la mente",
                          Icons.air,
                          Colors.teal,
                              () => context.read<GroundingBloc>().add(StartBreathingExercise()),
                        ),
                        const SizedBox(height: 20),
                        _buildExerciseCard(
                          context,
                          "Visualización Guiada",
                          "Imagina un lugar seguro para encontrar paz",
                          Icons.landscape,
                          Colors.blue,
                              () => context.read<GroundingBloc>().add(StartVisualizationExercise()),
                        ),
                        const SizedBox(height: 40),
                        _buildInfoFooter(),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildExerciseCard(
      BuildContext context,
      String title,
      String description,
      IconData icon,
      Color color,
      VoidCallback onPressed,
      ) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      shadowColor: color.withOpacity(0.3),
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: onPressed,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                color.withOpacity(0.1),
                color.withOpacity(0.05),
              ],
            ),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 30,
                  color: color,
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: (color is MaterialColor) ? color.shade700 : color,                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 20,
                color: color,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoFooter() {
    return Column(
      children: [
        const Text(
          "¿Cómo elegir una técnica?",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.blueGrey,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          "Prueba diferentes métodos y descubre cuál te ayuda más "
              "en momentos de estrés o ansiedad.",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade600,
          ),
        ),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: Colors.blue.shade100,
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.lightbulb_outline,
                color: Colors.amber.shade600,
              ),
              const SizedBox(width: 10),
              Text(
                "Practica regularmente para mejores resultados",
                style: TextStyle(
                  color: Colors.blue.shade800,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}