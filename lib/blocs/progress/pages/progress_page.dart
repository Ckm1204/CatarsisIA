// lib/presentation/pages/progress/progress_page.dart
import 'package:app_catarsis/blocs/progress/widgets/mood_bar_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/statisctic_event.dart';
import '../bloc/statistics_bloc.dart';
import '../widgets/mood_line.dart';
import '../widgets/mood_line_chart.dart';
import '../widgets/questions_average_chart.dart';

class ProgressPage extends StatelessWidget {
  const ProgressPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => StatisticsBloc()..add(LoadStatistics()),
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text('Mi Progreso'),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                MoodLineChartCard(),
                const SizedBox(height: 24),
                const QuestionsAverageChart(),
                const SizedBox(height: 24),
                //MoodBarChart(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}