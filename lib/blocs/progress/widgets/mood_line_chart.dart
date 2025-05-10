// lib/presentation/pages/progress/widgets/mood_line_chart.dart
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:collection/collection.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../bloc/statistics_bloc.dart';
import '../bloc/statistics_state.dart';

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
          final groupedData = _groupDataByTimespan(state.surveys);

          return Card(
            elevation: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'Progreso del Estado de Ánimo',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                                    value.toInt() < groupedData.length) {
                                  final date = groupedData[value.toInt()].date;
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Text(
                                      _formatDate(date, groupedData.length > 12),
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
                              getTitlesWidget: (value, meta) {
                                return Text(value.toInt().toString());
                              },
                            ),
                          ),
                          topTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          rightTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                        ),
                        minX: 0,
                        maxX: (groupedData.length - 1).toDouble(),
                        minY: 0,
                        maxY: 10,
                        lineBarsData: [
                          LineChartBarData(
                            spots: groupedData.mapIndexed((index, item) {
                              return FlSpot(
                                index.toDouble(),
                                item.averageScore,
                              );
                            }).toList(),
                            isCurved: true,
                            color: Theme.of(context).primaryColor,
                            dotData: const FlDotData(show: true),
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
          child: Text('No hay datos disponibles'),
        );
      },
    );
  }

  String _formatDate(DateTime date, bool isMonthly) {
    return isMonthly
        ? DateFormat('MMM yy').format(date)
        : DateFormat('dd/MM').format(date);
  }

  List<GroupedData> _groupDataByTimespan(List<Map<String, dynamic>> surveys) {
    final grouped = groupBy<Map<String, dynamic>, String>(
      surveys,
      (survey) {
        final timestamp = survey['timestamp'] as Timestamp;
        final date = timestamp.toDate();
        return surveys.length > 30
            ? DateFormat('yyyy-MM').format(date)
            : DateFormat('yyyy-ww').format(date);
      },
    );

    return grouped.entries.map((entry) {
      final avgScore = entry.value
          .map((s) => (s['score'] as num).toDouble())
          .reduce((a, b) => a + b) /
          entry.value.length;

      final firstSurvey = entry.value.first;
      final timestamp = firstSurvey['timestamp'] as Timestamp;
      final date = timestamp.toDate();

      return GroupedData(date, avgScore);
    }).toList()
      ..sort((a, b) => a.date.compareTo(b.date));
  }
}

class GroupedData {
  final DateTime date;
  final double averageScore;

  GroupedData(this.date, this.averageScore);
}