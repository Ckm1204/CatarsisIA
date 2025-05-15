// question_model.dart
class Question {
  final String text;
  final double score;

  Question({required this.text, this.score = 0});

  Question copyWith({String? text, double? score}) {
    return Question(
      text: text ?? this.text,
      score: score ?? this.score,
    );
  }
}
