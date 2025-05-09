// lib/presentation/pages/progress/progress_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../bloc/statisctic_event.dart';
import '../bloc/statistics_bloc.dart';
import '../widgets/mood_bar_chart.dart';
import '../widgets/mood_line_chart.dart';


class ProgressPage extends StatelessWidget {
  const ProgressPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => StatisticsBloc()..add(LoadStatistics()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Mi Progreso'),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const MoodLineChart(),
                const SizedBox(height: 24),
                 MoodBarChart(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}