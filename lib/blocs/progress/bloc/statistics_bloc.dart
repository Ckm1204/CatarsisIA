// lib/presentation/pages/progress/bloc/statistics_bloc.dart
import 'package:app_catarsis/blocs/progress/bloc/statisctic_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'statistics_state.dart';

class StatisticsBloc extends Bloc<StatisticsEvent, StatisticsState> {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth ;

  StatisticsBloc({
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance,
        super(StatisticsInitial()) {
    on<LoadStatistics>(_onLoadStatistics);
    on<RefreshStatistics>(_onRefreshStatistics);
  }

  Future<List<Map<String, dynamic>>> fetchUserSurveys() async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw Exception('Usuario no autenticado');
      }

      final querySnapshot = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('surveys_mood')
          .orderBy('timestamp', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => {
        ...doc.data(),
        'userId': user.uid,
        'id': doc.id,
      })
          .toList();
    } catch (e) {
      throw Exception('Error al cargar los datos: $e');
    }
  }



  Future<void> _onLoadStatistics(
      LoadStatistics event,
      Emitter<StatisticsState> emit,
      ) async {
    try {
      emit(StatisticsLoading());
      final surveys = await _loadSurveys();
      if (surveys.isEmpty) {
        emit(const StatisticsError('No hay datos disponibles'));
      } else {
        emit(StatisticsLoaded(surveys));
      }
    } catch (e) {
      emit(StatisticsError(e.toString()));
    }
  }

  Future<void> _onRefreshStatistics(
      RefreshStatistics event,
      Emitter<StatisticsState> emit,
      ) async {
    try {
      final surveys = await _loadSurveys();
      if (surveys.isEmpty) {
        emit(const StatisticsError('No hay datos disponibles'));
      } else {
        emit(StatisticsLoaded(surveys));
      }
    } catch (e) {
      emit(StatisticsError(e.toString()));
    }
  }

  Future<List<Map<String, dynamic>>> _loadSurveys() async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('Usuario no autenticado');
    }

    final querySnapshot = await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('surveys_mood')
        .orderBy('timestamp', descending: false)
        .get();

    return querySnapshot.docs.map((doc) {
      final data = doc.data();
      return {
        'id': doc.id,
        'userId': user.uid,
        'timestamp': data['timestamp'],
        'score': data['score'],
        'answers': data['answers'],
      };
    }).toList();
  }
}