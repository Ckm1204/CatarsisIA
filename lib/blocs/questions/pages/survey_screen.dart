// screens/survey_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app_catarsis/blocs/questions/bloc/survey_bloc.dart';
import 'package:app_catarsis/blocs/questions/bloc/survey_event.dart';
import 'package:app_catarsis/blocs/questions/bloc/survey_state.dart';

import '../../../utils/constants/survey_mood.dart';
import '../../../utils/error/unauthenticated_screen.dart';
import '../../auth/auth_bloc.dart';
import '../../auth/auth_state.dart';

class SurveyScreen extends StatelessWidget {
  const SurveyScreen({super.key});

  @override
    Widget build(BuildContext context) {
      return BlocProvider(
        create: (_) => SurveyBloc(kSurveyQuestions),
        child: MultiBlocListener(
          listeners: [
            BlocListener<SurveyBloc, SurveyState>(
              listener: (context, state) {
                if (state is SurveyCompleted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('¡Gracias por responder!')),
                  );
                  Navigator.of(context).pushReplacementNamed('/home');
                }
              },
            ),
            BlocListener<AuthBloc, AuthState>(
              listener: (context, state) {
                if (state is AuthUnauthenticated) {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => UnauthenticatedScreen()),
                  );
                }
              },
            ),
          ],
      child: Scaffold(
        appBar: AppBar(title: const Text('Encuesta de ánimo')),
        body: BlocBuilder<SurveyBloc, SurveyState>(
          builder: (context, state) {
            if (state is SurveyInitial || state is SurveyInProgress) {
              final questions = (state as dynamic).questions;
              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: questions.length + 1,
                itemBuilder: (context, index) {
                  if (index == questions.length) {
                    return ElevatedButton(
                      onPressed: () =>
                          context.read<SurveyBloc>().add(SubmitSurvey()),
                      child: const Text('Enviar respuestas'),
                    );
                  }
                  final question = questions[index];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(question.text,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      Slider(
                        value: question.score,
                        onChanged: (value) =>
                            context.read<SurveyBloc>().add(
                              UpdateAnswer(index: index, score: value),
                            ),
                        min: 0,
                        max: 10,
                        divisions: 10,
                        label: question.score.toString(),
                      ),
                      const SizedBox(height: 16),
                    ],
                  );
                },
              );
            } else if (state is SurveyCompleted) {
              return const Center(child: Text('¡Gracias por responder!'));
            } else if (state is SurveyError) {
              return Center(child: Text(state.message));
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    ));
  }
}
