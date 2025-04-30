// survey_state.dart
import 'package:app_catarsis/domain/entities/question_model.dart';

abstract class SurveyState {}

class SurveyInitial extends SurveyState {
  final List<Question> questions;
  SurveyInitial(this.questions);
}

class SurveyInProgress extends SurveyState {
  final List<Question> questions;
  SurveyInProgress(this.questions);
}

class SurveyCompleted extends SurveyState {}

class SurveyError extends SurveyState {
  final String message;
  SurveyError(this.message);
}
