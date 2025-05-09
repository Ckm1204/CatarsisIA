// lib/presentation/pages/progress/widgets/mood_line_chart.dart
import 'package:app_catarsis/blocs/progress/bloc/statistics_bloc.dart';
import 'package:app_catarsis/blocs/progress/bloc/statistics_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MoodLineChart extends StatelessWidget {
  const MoodLineChart({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StatisticsBloc, StatisticsState>(
      builder: (context, state) {
        if (state is StatisticsLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is StatisticsError) {
          return Center(child: Text(state.message));
        }

        if (state is StatisticsLoaded && state.surveys.isNotEmpty) {
          final spots = state.surveys.asMap().entries.map((entry) {
            return FlSpot(
              entry.key.toDouble(),
              entry.value['score'].toDouble(),
            );
          }).toList();

          return Card(
            elevation: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'Progreso del Estado de Ánimo',
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
                    child: LineChart(
                      LineChartData(
                        gridData: const FlGridData(show: true),
                        titlesData: FlTitlesData(
                          show: true,
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 30,
                              getTitlesWidget: (value, meta) {
                                if (value.toInt() >= 0 &&
                                    value.toInt() < state.surveys.length) {
                                  final date = (state.surveys[value.toInt()]
                                          ['timestamp'] as Timestamp)
                                      .toDate();
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Text(
                                      DateFormat('dd/MM').format(date),
                                      style: const TextStyle(fontSize: 10),
                                    ),
                                  );
                                }
                                return const Text('');
                              },
                            ),
                          ),
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 40,
                            ),
                          ),
                          topTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          rightTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                        ),
                        borderData: FlBorderData(
                          show: true,
                        ),
                        minX: 0,
                        maxX: (state.surveys.length - 1).toDouble(),
                        minY: 0,
                        maxY: 10,
                        lineBarsData: [
                          LineChartBarData(
                            spots: spots,
                            isCurved: true,
                            color: Theme.of(context).primaryColor,
                            dotData: FlDotData(show: true),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        return const Center(
          child: Text('No hay datos de cuestionarios disponibles'),
        );
      },
    );
  }
}