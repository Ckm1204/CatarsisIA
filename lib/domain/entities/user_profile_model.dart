class UserProfile {
  final DateTime birthDate;
  final String gender;
  final String educationLevel;
  final String occupation;
  final String socioeconomicLevel;
  final String emotionalSupport;
  final String livingSituation;

  UserProfile({
    required this.birthDate,
    required this.gender,
    required this.educationLevel,
    required this.occupation,
    required this.socioeconomicLevel,
    required this.emotionalSupport,
    required this.livingSituation,
  });

  Map<String, dynamic> toJson() {
    return {
      'birthDate': birthDate.toIso8601String(),
      'gender': gender,
      'educationLevel': educationLevel,
      'occupation': occupation,
      'socioeconomicLevel': socioeconomicLevel,
      'emotionalSupport': emotionalSupport,
      'livingSituation': livingSituation,
    };
  }
}
