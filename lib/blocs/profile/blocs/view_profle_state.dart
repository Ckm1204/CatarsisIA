// lib/blocs/view_profile/bloc/view_profile_state.dart
import '../../../domain/entities/user_profile_model.dart';

abstract class ViewProfileState {
  const ViewProfileState();
}

class ViewProfileInitial extends ViewProfileState {}
class ViewProfileLoading extends ViewProfileState {}
class ViewProfileLoaded extends ViewProfileState {
  final UserProfile profile;
  ViewProfileLoaded(this.profile);
}
class ViewProfileError extends ViewProfileState {
  final String message;
  ViewProfileError(this.message);
}