// lib/blocs/question_profile/bloc/profile_bloc.dart
import 'package:app_catarsis/blocs/question_profile/bloc/profile_event.dart';
import 'package:app_catarsis/blocs/question_profile/bloc/profile_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final FirebaseFirestore _firestore;
  final String userId;

  ProfileBloc(this._firestore, this.userId) : super(ProfileInitial()) {
    on<SaveProfileData>(_onSaveProfile);
  }

  Future<void> _onSaveProfile(
    SaveProfileData event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      emit(ProfileLoading());

      await _firestore
          .collection('users')
          .doc(userId)
          .collection('profile')
          .doc('data') // Using a fixed document ID 'data'
          .set({
            'profile': event.profile.toJson(),
            'profileCompleted': true,
            'updatedAt': FieldValue.serverTimestamp(),
          }, SetOptions(merge: true));

      emit(ProfileSuccess());
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }
}