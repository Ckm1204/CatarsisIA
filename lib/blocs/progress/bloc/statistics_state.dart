// lib/presentation/pages/progress/bloc/statistics_state.dart
import 'package:equatable/equatable.dart';

abstract class StatisticsState extends Equatable {
  const StatisticsState();

  @override
  List<Object> get props => [];
}



class StatisticsInitial extends StatisticsState {}

class StatisticsLoading extends StatisticsState {}

class StatisticsLoaded extends StatisticsState {
  final List<Map<String, dynamic>> surveys;

  const StatisticsLoaded(this.surveys);

  @override
  List<Object> get props => [surveys];
}

class StatisticsError extends StatisticsState {
  final String message;

  const StatisticsError(this.message);

  @override
  List<Object> get props => [message];
}