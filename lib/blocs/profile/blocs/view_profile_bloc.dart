// lib/blocs/view_profile/bloc/view_profile_bloc.dart
import 'package:app_catarsis/blocs/profile/blocs/view_profile_event.dart';
import 'package:app_catarsis/blocs/profile/blocs/view_profle_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/user_profile_model.dart';

class ViewProfileBloc extends Bloc<ViewProfileEvent, ViewProfileState> {
  ViewProfileBloc() : super(ViewProfileInitial()) {
    on<LoadProfile>(_onLoadProfile);
  }

  Future<void> _onLoadProfile(
    LoadProfile event,
    Emitter<ViewProfileState> emit,
  ) async {
    try {
      emit(ViewProfileLoading());

      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception('Usuario no autenticado');

      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('profile')
          .doc('data')
          .get();

      if (!doc.exists) throw Exception('Perfil no encontrado');

      final data = doc.data();
      final profileMap = data?['profile'] as Map<String, dynamic>?;

      if (profileMap == null) throw Exception('Datos de perfil no encontrados');

      final profile = UserProfile(
        birthDate: data?['birthDate'] != null
            ? (data!['birthDate'] as Timestamp).toDate()
            : DateTime.now(),
        educationLevel: profileMap['educationLevel'] ?? 'No especificado',
        emotionalSupport: profileMap['emotionalSupport'] ?? 'No especificado',
        gender: profileMap['gender'] ?? 'No especificado',
        livingSituation: profileMap['livingSituation'] ?? 'No especificado',
        occupation: profileMap['occupation'] ?? 'No especificado',
        socioeconomicLevel: profileMap['socioeconomicLevel'] ?? 'No especificado',
      );


      emit(ViewProfileLoaded(profile));
    } catch (e) {
      emit(ViewProfileError(e.toString()));
    }
  }
}