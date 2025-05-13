import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:collection/collection.dart';
import '../bloc/statisctic_event.dart';
import '../bloc/statistics_bloc.dart';
import '../bloc/statistics_state.dart';
import 'package:firebase_auth/firebase_auth.dart';

enum TimelineFilter {
  daily,
  weekly,
  monthly,
}

class GroupedData {
  final DateTime date;
  final double score;

  GroupedData(this.date, this.score);
}

class MoodLineChart extends StatefulWidget {
  const MoodLineChart({super.key});

  @override
  State<MoodLineChart> createState() => _MoodLineChartState();
}

class _MoodLineChartState extends State<MoodLineChart> {
  TimelineFilter _selectedFilter = TimelineFilter.weekly;
  bool showAvg = false;
  final List<Color> gradientColors = [
    Colors.cyan,
    Colors.blue,
  ];

  @override
  void initState() {
    super.initState();
    context.read<StatisticsBloc>().add(LoadStatistics());
  }

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
          final groupedData = _groupDataByTimespan(state.surveys, _selectedFilter);

          return Card(
            elevation: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                SizedBox(
                  height: 300,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: LineChart(
                      showAvg ? _getAvgData(groupedData) : _getMainData(groupedData),
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

Widget _buildHeader() {
  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: DropdownButton<TimelineFilter>(
            value: _selectedFilter,
            onChanged: (TimelineFilter? newValue) {
              if (newValue != null) {
                setState(() {
                  _selectedFilter = newValue;
                });
              }
            },
            items: TimelineFilter.values.map((TimelineFilter filter) {
              return DropdownMenuItem<TimelineFilter>(
                value: filter,
                child: Text(filter.toString().split('.').last),
              );
            }).toList(),
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Avg.',
              style: TextStyle(
                fontSize: 12,
                color: showAvg ? Colors.black : Colors.black.withOpacity(0.5),
              ),
            ),
            const SizedBox(width: 4),
            Switch(
              value: showAvg,
              onChanged: (bool val) {
                setState(() {
                  showAvg = val;
                });
              },
            ),
          ],
        ),
      ],
    ),
  );
}
  LineChartData _getMainData(List<GroupedData> groupedData) {
    return LineChartData(
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          getTooltipItems: (touchedSpots) {
            return touchedSpots.map((spot) {
              final data = groupedData[spot.x.toInt()];
              return LineTooltipItem(
                '${_formatDate(data.date, _selectedFilter)}\n${spot.y.toStringAsFixed(1)}',
                const TextStyle(color: Colors.black),
              );
            }).toList();
          },
        ),
      ),
      gridData: _getGridData(),
      titlesData: _getTitlesData(groupedData),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: const Color(0xff37434d)),
      ),
      minX: 0,
      maxX: (groupedData.length - 1).toDouble(),
      minY: 0,
      maxY: 10,
      lineBarsData: [
        LineChartBarData(
          spots: groupedData
              .asMap()
              .entries
              .map((e) => FlSpot(e.key.toDouble(), e.value.score))
              .toList(),
          isCurved: true,
          gradient: LinearGradient(colors: gradientColors),
          barWidth: 3,
          dotData: const FlDotData(show: true),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: gradientColors.map((color) => color.withOpacity(0.3)).toList(),
            ),
          ),
        ),
      ],
    );
  }

  LineChartData _getAvgData(List<GroupedData> groupedData) {
    final avgScore = groupedData.map((e) => e.score).reduce((a, b) => a + b) / groupedData.length;

    return LineChartData(
      lineTouchData: const LineTouchData(enabled: false),
      gridData: _getGridData(),
      titlesData: _getTitlesData(groupedData),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: const Color(0xff37434d)),
      ),
      minX: 0,
      maxX: (groupedData.length - 1).toDouble(),
      minY: 0,
      maxY: 10,
      lineBarsData: [
        LineChartBarData(
          spots: groupedData
              .asMap()
              .entries
              .map((e) => FlSpot(e.key.toDouble(), avgScore))
              .toList(),
          isCurved: true,
          gradient: LinearGradient(
            colors: [gradientColors[0].withOpacity(0.5), gradientColors[1].withOpacity(0.5)],
          ),
          barWidth: 3,
          isStrokeCapRound: true,
          dotData: const FlDotData(show: false),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: gradientColors.map((color) => color.withOpacity(0.1)).toList(),
            ),
          ),
        ),
      ],
    );
  }

  FlGridData _getGridData() {
    return FlGridData(
      show: true,
      drawVerticalLine: true,
      horizontalInterval: 1,
      verticalInterval: 1,
      getDrawingHorizontalLine: (value) {
        return FlLine(
          color: Colors.grey[300],
          strokeWidth: 1,
        );
      },
      getDrawingVerticalLine: (value) {
        return FlLine(
          color: Colors.grey[300],
          strokeWidth: 1,
        );
      },
    );
  }

  FlTitlesData _getTitlesData(List<GroupedData> groupedData) {
    return FlTitlesData(
      show: true,
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          getTitlesWidget: (value, meta) {
            if (value.toInt() >= 0 && value.toInt() < groupedData.length) {
              return Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  _formatDate(groupedData[value.toInt()].date, _selectedFilter),
                  style: const TextStyle(fontSize: 10),
                ),
              );
            }
            return const Text('');
          },
          reservedSize: 30,
        ),
      ),
      leftTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          getTitlesWidget: (value, meta) {
            return Text(value.toInt().toString());
          },
          reservedSize: 40,
        ),
      ),
      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
    );
  }

  List<GroupedData> _groupDataByTimespan(
    List<Map<String, dynamic>> surveys,
    TimelineFilter filter,
  ) {
    final grouped = groupBy<Map<String, dynamic>, String>(
      surveys,
      (survey) {
        final timestamp = survey['timestamp'] as Timestamp;
        final date = timestamp.toDate();
        switch (filter) {
          case TimelineFilter.daily:
            return DateFormat('yyyy-MM-dd').format(date);
          case TimelineFilter.weekly:
            return DateFormat('yyyy-ww').format(date);
          case TimelineFilter.monthly:
            return DateFormat('yyyy-MM').format(date);
        }
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

  String _formatDate(DateTime date, TimelineFilter filter) {
    switch (filter) {
      case TimelineFilter.daily:
        return DateFormat('dd/MM').format(date);
      case TimelineFilter.weekly:
        return DateFormat('dd/MM').format(date);
      case TimelineFilter.monthly:
        return DateFormat('MMM yy').format(date);
    }
  }
}