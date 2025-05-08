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

class SurveyScreen extends StatefulWidget {
  const SurveyScreen({super.key});

  @override
  State<SurveyScreen> createState() => _SurveyScreenState();
}

class _SurveyScreenState extends State<SurveyScreen> {
  bool isFirstPage = true;

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
                //Todo: agregar que si le da mas de un clik solo se guarde una vez
                Navigator.of(context).pushReplacementNamed('/profile_initial');
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
                final startIndex = isFirstPage ? 0 : 6;
                final endIndex = isFirstPage ? 6 : questions.length;

                return Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: endIndex - startIndex,
                        itemBuilder: (context, index) {
                          final questionIndex = startIndex + index;
                          final question = questions[questionIndex];
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
                                      UpdateAnswer(index: questionIndex, score: value),
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
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ElevatedButton(
                        onPressed: () {
                          if (isFirstPage) {
                            setState(() => isFirstPage = false);
                          } else {
                            context.read<SurveyBloc>().add(SubmitSurvey());
                          }
                        },
                        child: Text(isFirstPage ? 'Siguiente' : 'Enviar respuestas'),
                      ),
                    ),
                  ],
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
      ),
    );
  }
}
