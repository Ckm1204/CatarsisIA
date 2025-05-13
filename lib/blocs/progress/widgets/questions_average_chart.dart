// lib/presentation/pages/progress/widgets/questions_average_chart.dart
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../bloc/statistics_bloc.dart';
import '../bloc/statistics_state.dart';
import '../../../../utils/constants/survey_mood.dart';

class QuestionsAverageChart extends StatelessWidget {
  const QuestionsAverageChart({super.key});

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
          final questionAverages = _calculateQuestionAverages(state.surveys);

          return Card(
            elevation: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'Promedio por Pregunta',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  height: 300,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: BarChart(
                      BarChartData(
                        alignment: BarChartAlignment.start,
                        maxY: 10,
                        minY: 0,
                        groupsSpace: 12,
                        barTouchData: BarTouchData(
                          touchTooltipData: BarTouchTooltipData(
                            getTooltipColor: (context) => Colors.grey,
                            getTooltipItem: (group, groupIndex, rod, rodIndex) {
                              return BarTooltipItem(
                                '${kSurveyQuestions[group.x.toInt()]}\n${rod.toY.toStringAsFixed(1)}',
                                const TextStyle(color: Colors.black),
                              );
                            },
                          ),
                        ),
                        titlesData: FlTitlesData(
                          show: true,
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                return Text(
                                  '${(value + 1).toInt()}',
                                  style: const TextStyle(fontSize: 10),
                                );
                              },
                              reservedSize: 30,
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
                        borderData: FlBorderData(show: false),
                        barGroups: questionAverages.asMap().entries.map((entry) {
                          return BarChartGroupData(
                            x: entry.key,
                            barRods: [
                              BarChartRodData(
                                toY: entry.value,
                                color: Theme.of(context).primaryColor,
                                width: 16,
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

        return const Center(
          child: Text('No hay datos disponibles'),
        );
      },
    );
  }

  List<double> _calculateQuestionAverages(List<Map<String, dynamic>> surveys) {
    if (surveys.isEmpty) return [];

    final List<List<double>> questionScores = List.generate(
      kSurveyQuestions.length,
      (_) => <double>[],
    );

    for (final survey in surveys) {
      final List<dynamic> answers = survey['answers'] as List<dynamic>;
      for (var i = 0; i < answers.length && i < kSurveyQuestions.length; i++) {
        final double score = (answers[i] ?? 0).toDouble();
        questionScores[i].add(score);
      }
    }

    return questionScores.map((questionScores) {
      if (questionScores.isEmpty) return 0.0;
      final sum = questionScores.reduce((a, b) => a + b);
      return sum / questionScores.length;
    }).toList();
  }
}