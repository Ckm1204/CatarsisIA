import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../bloc/statistics_bloc.dart';
import '../bloc/statistics_state.dart';

class MoodLineChartCard extends StatefulWidget {
  const MoodLineChartCard({super.key});

  @override
  State<MoodLineChartCard> createState() => _MoodLineChartCardState();
}

class _MoodLineChartCardState extends State<MoodLineChartCard> {
  String selectedTimeRange = 'Semana';
  String selectedQuestion = 'Todas';
  bool showAverage = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.5,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Estado de ánimo - Timeline',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: Icon(
                      showAverage ? Icons.show_chart : Icons.bar_chart,
                      color: Colors.cyan,
                    ),
                    onPressed: () => setState(() => showAverage = !showAverage),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 16,
                children: [
                  DropdownButton<String>(
                    value: selectedTimeRange,
                    items: ['Día', 'Semana', 'Mes']
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (value) {
                      if (value != null) setState(() => selectedTimeRange = value);
                    },
                  ),
                  /*
                  DropdownButton<String>(
                    value: selectedQuestion,
                    items: ['Todas', 'Pregunta 1', 'Pregunta 2']
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (value) {
                      if (value != null) setState(() => selectedQuestion = value);
                    },
                  ),
                  */
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: BlocBuilder<StatisticsBloc, StatisticsState>(
                  builder: (context, state) {
                    if (state is StatisticsLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is StatisticsError) {
                      return Center(child: Text(state.message));
                    } else if (state is StatisticsLoaded) {
                      final surveys = _filterData(state.surveys);

                      if (surveys.isEmpty) {
                        return const Center(child: Text("No hay datos disponibles"));
                      }

                      return _buildChart(surveys);
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChart(List<Map<String, dynamic>> surveys) {
    final spots = <FlSpot>[];
    final labels = <int, String>{};

    for (var i = 0; i < surveys.length; i++) {
      final data = surveys[i];
      final score = (data['score'] as num).toDouble();
      final timestamp = (data['date'] as DateTime);

      spots.add(FlSpot(i.toDouble(), score));
      labels[i] = DateFormat('dd/MM').format(timestamp);
    }

    if (showAverage && spots.isNotEmpty) {
      final avgScore = surveys.fold<double>(
        0,
            (sum, item) => sum + (item['score'] as num).toDouble(),
      ) /
          surveys.length;
      spots.clear();
      spots.add(FlSpot(0, avgScore));
      spots.add(FlSpot(surveys.length - 1.toDouble(), avgScore));
    }

    return LineChart(
      LineChartData(
        minY: 0,
        maxY: 100,
        minX: 0,
        maxX: spots.length > 1 ? (spots.length - 1).toDouble() : 1,
        gridData: FlGridData(show: true),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 1,
              getTitlesWidget: (value, meta) {
                final label = labels[value.toInt()] ?? '';
                return SideTitleWidget(
                  angle: 45,
                  meta: meta,
                  space: 8,
                  child: Text(
                    label,
                    style: const TextStyle(fontSize: 10),
                  ),
                );
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 20,
              getTitlesWidget: (value, meta) =>
                  Text('${value.toInt()}', style: const TextStyle(fontSize: 10)),
              reservedSize: 28,
            ),
          ),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: true),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: !showAverage,
            barWidth: 3,
            color: Colors.cyan,
            belowBarData: BarAreaData(
              show: true,
              color: Colors.cyan.withOpacity(0.2),
            ),
            dotData: FlDotData(show: spots.length < 30),
          ),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _filterData(List<Map<String, dynamic>> surveys) {
    final now = DateTime.now();
    final startOfToday = DateTime(now.year, now.month, now.day);

    // Agrupar según el filtro
    final Map<String, List<double>> groupedScores = {};

    for (final survey in surveys) {
      final timestamp = (survey['timestamp'] as Timestamp).toDate();
      String key = '';

      switch (selectedTimeRange) {
        case 'Mes':
          if (timestamp.year == now.year &&
              timestamp.month == now.month &&
              timestamp.day == now.day) {
            key = DateFormat('yyyy-MM-dd').format(timestamp);
          }
          break;

        case 'Semana':
          final startOfWeek = startOfToday.subtract(Duration(days: startOfToday.weekday - 1));
          final endOfWeek = startOfWeek.add(const Duration(days: 6));

          if (timestamp.isAfter(startOfWeek.subtract(const Duration(seconds: 1))) &&
              timestamp.isBefore(endOfWeek.add(const Duration(days: 1)))) {
            // Agrupar por día dentro de la semana
            key = DateFormat('yyyy-MM-dd').format(timestamp);
          }
          break;

        case 'Día':
          if (timestamp.year == now.year && timestamp.month == now.month) {
            // Agrupar por día dentro del mes
            key = DateFormat('yyyy-MM-dd').format(timestamp);
          }
          break;

        default:
          key = DateFormat('yyyy-MM-dd').format(timestamp);
      }

      if (key.isNotEmpty) {
        groupedScores.putIfAbsent(key, () => []);
        groupedScores[key]!.add((survey['score'] as num).toDouble());
      }
    }

    // Convertimos el mapa a lista de mapas con promedio
    final result = groupedScores.entries.map((entry) {
      final average = entry.value.reduce((a, b) => a + b) / entry.value.length;
      return {
        'date': DateFormat('yyyy-MM-dd').parse(entry.key),
        'score': average,
      };
    }).toList();

    // Ordenar por fecha ascendente
    result.sort((a, b) => (a['date'] as DateTime).compareTo(b['date'] as DateTime));

    return result;
  }

}