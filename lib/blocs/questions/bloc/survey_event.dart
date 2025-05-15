// survey_event.dart
abstract class SurveyEvent {}

class UpdateAnswer extends SurveyEvent {
  final int index;
  final double score;

  UpdateAnswer({required this.index, required this.score});
}

class SubmitSurvey extends SurveyEvent {}