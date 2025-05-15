// lib/presentation/pages/progress/bloc/statistics_event.dart
import 'package:equatable/equatable.dart';

abstract class StatisticsEvent extends Equatable {
  const StatisticsEvent();

  @override
  List<Object> get props => [];
}

class LoadStatistics extends StatisticsEvent {}

class RefreshStatistics extends StatisticsEvent {}