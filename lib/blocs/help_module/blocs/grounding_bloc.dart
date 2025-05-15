import 'package:flutter_bloc/flutter_bloc.dart';
import 'grounding_event.dart';
import 'grounding_state.dart';

class GroundingBloc extends Bloc<GroundingEvent, GroundingState> {
  GroundingBloc() : super(GroundingInitial()) {
    on<StartGroundingExercise>((event, emit) {
      emit(GroundingExerciseInProgress());
    });
    on<StartBreathingExercise>((event, emit) {
      emit(BreathingExerciseInProgress());
    });
    on<StartVisualizationExercise>((event, emit) {
      emit(VisualizationInProgress());
    });
  }
}
