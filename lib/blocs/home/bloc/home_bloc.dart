// lib/modules/home/bloc/home_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(const HomeState()) {
    on<NavigationIndexChanged>(_onNavigationIndexChanged);
  }

  void _onNavigationIndexChanged(
    NavigationIndexChanged event,
    Emitter<HomeState> emit,
  ) {
    emit(state.copyWith(currentIndex: event.index));
  }
}