// lib/blocs/question_profile/bloc/profile_event.dart
import 'package:app_catarsis/domain/entities/user_profile_model.dart';

abstract class ProfileEvent {}

class SaveProfileData extends ProfileEvent {
  final UserProfile profile;
  SaveProfileData(this.profile);
}

class ProfileInProgress extends ProfileEvent {
  final bool isInProgress;
  ProfileInProgress(this.isInProgress);
}

class UpdateField extends ProfileEvent {
  final String field;
  final dynamic value;
  UpdateField(this.field, this.value);
}