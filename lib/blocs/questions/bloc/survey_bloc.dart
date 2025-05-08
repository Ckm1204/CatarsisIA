// survey_bloc.dart
import 'package:app_catarsis/blocs/questions/bloc/survey_event.dart';
import 'package:app_catarsis/blocs/questions/bloc/survey_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:app_catarsis/domain/entities/question_model.dart';

class SurveyBloc extends Bloc<SurveyEvent, SurveyState> {
  SurveyBloc(List<String> questionTexts)
      : super(SurveyInitial(
    questionTexts.map((q) => Question(text: q)).toList(),
  )) {
    on<UpdateAnswer>((event, emit) {
      final currentState = state;
      if (currentState is SurveyInitial || currentState is SurveyInProgress) {
        final questions = (currentState as dynamic).questions as List<Question>;
        final updatedQuestions = List<Question>.from(questions);
        updatedQuestions[event.index] =
            updatedQuestions[event.index].copyWith(score: event.score);
        emit(SurveyInProgress(updatedQuestions));
      }
    });



    on<SubmitSurvey>((event, emit) async {
      try {
        final currentState = state;
        if (currentState is SurveyInProgress) {
          final answers = currentState.questions.map((q) => q.score).toList();
          final texts = currentState.questions.map((q) => q.text).toList();
          await saveSurvey(answers, texts);
          emit(SurveyCompleted());
        }
      } catch (e) {
        emit(SurveyError("Error al guardar la encuesta: $e"));
      }
    });
  }


  // Todo: Implementar pantalla de usuario no autenticado
  // TODO: Implementar pantalla de error

  Future<void> saveSurvey(List<double> answers, List<String> questions) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      emit(SurveyError("Usuario no autenticado"));
      return;
    }

    final total = answers.reduce((a, b) => a + b);
    final surveyData = {
      'timestamp': FieldValue.serverTimestamp(),
      'answers': answers,
      'questions': questions,
      'score': total,
    };

    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('surveys_mood')
        .add(surveyData);
  }
}
