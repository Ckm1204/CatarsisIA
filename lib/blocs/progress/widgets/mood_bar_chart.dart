// lib/presentation/pages/progress/widgets/mood_bar_chart.dart
import 'package:app_catarsis/blocs/progress/bloc/statistics_bloc.dart';
import 'package:app_catarsis/blocs/progress/bloc/statistics_state.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MoodBarChart extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StatisticsBloc, StatisticsState>(
      builder: (context, state) {
        if (state is StatisticsLoaded && state.surveys.isNotEmpty) {
          return Card(
            elevation: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'Distribución de Puntuaciones',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  height: 300,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: BarChart(
                      BarChartData(
                        alignment: BarChartAlignment.spaceAround,
                        maxY: state.surveys
                                .map((s) => s['score'])
                                .reduce((a, b) => a > b ? a : b)
                                .toDouble() +
                            2,
                        barTouchData: BarTouchData(enabled: true),
                        titlesData: const FlTitlesData(
                          show: true,
                          topTitles:
                              AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          rightTitles:
                              AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        ),
                        barGroups: state.surveys.asMap().entries.map((entry) {
                          return BarChartGroupData(
                            x: entry.key,
                            barRods: [
                              BarChartRodData(
                                toY: entry.value['score'].toDouble(),
                                color: Theme.of(context).primaryColor,
                                width: 16,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}