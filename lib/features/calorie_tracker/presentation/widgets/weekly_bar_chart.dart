import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WeeklyBarChart extends StatefulWidget {
  final Map<DateTime, Map<String, dynamic>> nutrientData;
  final List<DateTime> keys;
  final String keyName;
  final String charTitle;

  const WeeklyBarChart({
    super.key,
    required this.nutrientData,
    required this.keys,
    required this.keyName,
    required this.charTitle,
  });

  @override
  State<WeeklyBarChart> createState() => _WeeklyBarChartState();
}

class _WeeklyBarChartState extends State<WeeklyBarChart> {
  int currentWeek = 0;
  late List<int> weeklyData;

  @override
  void initState() {
    super.initState();
    _prepareWeeklyData();
  }

  @override
  void didUpdateWidget(covariant WeeklyBarChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.nutrientData != widget.nutrientData ||
        oldWidget.keys != widget.keys) {
      _prepareWeeklyData();
    }
  }

  void _prepareWeeklyData() {
    weeklyData =
        widget.keys.map((key) {
          var value = widget.nutrientData[key]?[widget.keyName];
          return value is num ? value.toInt() : 0;
        }).toList();
  }

  int getMax(List<int> list) {
    int max = 0;
    for (final ele in list) {
      if (ele > max) max = ele;
    }
    return max;
  }

  @override
  Widget build(BuildContext context) {
    int start = currentWeek * 7;
    int end = (start + 7).clamp(0, weeklyData.length);
    List<int> currentData = weeklyData.sublist(start, end);

    return Column(
      children: [
        // Prev and Next Buttons
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton(
              onPressed:
                  currentWeek > 0 ? () => setState(() => currentWeek--) : null,
              child: Text("Prev"),
            ),
            Text(widget.charTitle, style: TextStyle(fontSize: 18)),
            ElevatedButton(
              onPressed:
                  (currentWeek + 1) * 7 < weeklyData.length
                      ? () => setState(() => currentWeek++)
                      : null,
              child: Text("Next"),
            ),
          ],
        ),

        SizedBox(height: 24),

        // Top labels for bar values
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(currentData.length, (index) {
            return Padding(
              padding: const EdgeInsets.only(left: 0),
              child: Text(
                '${currentData[index]} g',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
            );
          }),
        ),

        SizedBox(height: 8),

        // Bar chart
        SizedBox(
          height: 300,
          child: BarChart(
            BarChartData(
              maxY: getMax(weeklyData).toDouble(),
              barGroups: List.generate(currentData.length, (index) {
                double value = currentData[index].toDouble();
                return BarChartGroupData(
                  x: index,
                  barRods: [
                    BarChartRodData(
                      toY: value,
                      color: Colors.blue,
                      width: 20,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ],
                  barsSpace: 4,
                );
              }),
              titlesData: FlTitlesData(
                topTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      int index = value.toInt();
                      if (index < 0 || index >= currentData.length) {
                        return SizedBox.shrink();
                      }
                      String label = DateFormat(
                        'dd/MM',
                      ).format(widget.keys[start + index]);
                      return Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(label, style: TextStyle(fontSize: 12)),
                      );
                    },
                  ),
                ),
              ),
              barTouchData: BarTouchData(enabled: false), // No tooltip
              borderData: FlBorderData(show: false),
              gridData: FlGridData(show: false),
              alignment: BarChartAlignment.spaceAround,
            ),
            swapAnimationDuration: Duration(milliseconds: 300),
            swapAnimationCurve: Curves.easeInOut,
          ),
        ),
      ],
    );
  }
}
