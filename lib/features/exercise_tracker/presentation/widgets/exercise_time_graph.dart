import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ExerciseTimeBarChart extends StatefulWidget {
  final List<double> data; // e.g. [30, 45, 25, 60, 50, 70, 20]
  final List<String> labels; // e.g. ['M', 'T', 'W', 'T', 'F', 'S', 'S']
  final List<Color>? barColors; // Optional: List of colors for each bar
  final Color touchedBarColor;
  final Color barBackgroundColor;

  const ExerciseTimeBarChart({
    super.key,
    required this.data,
    required this.labels,
    this.barColors, // Now an optional list of colors
    this.touchedBarColor = Colors.green,
    this.barBackgroundColor = const Color(0xFFE0E0E0),
  });

  @override
  State<ExerciseTimeBarChart> createState() => _ExerciseTimeBarChartState();
}

class _ExerciseTimeBarChartState extends State<ExerciseTimeBarChart> {
  int touchedIndex = -1; // Kept for touch interaction and tooltips

  // Define a default set of colors if barColors is not provided
  List<Color> get _defaultBarColors => [
        Colors.blueAccent,
        Colors.orangeAccent,
        const Color.fromARGB(255, 105, 92, 87),
        Colors.tealAccent,
        Colors.redAccent,
        Colors.lightGreen,
        Colors.amber,
      ];

  // Helper function to format duration
  String _formatDuration(double minutes) {
    if (minutes >= 60) {
      // Convert to hours if 60 minutes or more
      double hours = minutes / 60;
      return '${hours.toStringAsFixed(1)} hr'; // Format to one decimal place
    } else {
      // Otherwise, show in minutes
      return '${minutes.toInt()} min';
    }
  }

  @override
  Widget build(BuildContext context) {
    // Check if any data point is 60 minutes or more to adjust the chart description
    bool showsHours = widget.data.any((value) => value >= 60);

    return AspectRatio(
      aspectRatio: 1.3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Weekly Exercise Time',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              // Dynamically change description based on data values
              showsHours ? 'Hours spent exercising each day' : 'Minutes spent exercising each day',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: BarChart(
                mainBarData(), // Always displays the main data
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Creates a single group of bar data for the chart.
  ///
  /// [x]: The index of the bar group.
  /// [y]: The value (height) of the bar.
  /// [isTouched]: True if this bar is currently being touched/hovered.
  /// [barColor]: The specific color for this bar.
  /// [width]: The width of the bar.
  /// [showTooltips]: List of rod indices to show tooltips for (usually just 0 for a single rod).
  BarChartGroupData makeGroupData(
    int x,
    double y, {
    bool isTouched = false,
    required Color barColor, // Now required to ensure each bar has a color
    double width = 22,
    List<int> showTooltips = const [],
  }) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: isTouched ? y : y, // Slightly increase height on touch
          color: isTouched ? widget.touchedBarColor : barColor, // Apply specific or touched color
          width: width,
          borderSide: isTouched
              ? BorderSide(color: widget.touchedBarColor.withOpacity(0.8))
              : BorderSide.none,
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: 100, // Maximum Y-axis value for the background rod
            color: widget.barBackgroundColor,
          ),
        ),
      ],
      showingTooltipIndicators: showTooltips,
    );
  }

  /// Generates the list of BarChartGroupData for all bars in the chart.
  ///
  /// It iterates through the provided [data] and assigns a color to each bar
  /// from `widget.barColors` or a default set, cycling through them if needed.
  List<BarChartGroupData> showingGroups(List<double> data) {
    final effectiveBarColors = widget.barColors ?? _defaultBarColors;
    return List.generate(data.length, (i) {
      // Calculate the color index to cycle through the available colors
      final colorIndex = i % effectiveBarColors.length;
      return makeGroupData(
        i,
        data[i],
        isTouched: i == touchedIndex,
        barColor: effectiveBarColors[colorIndex], // Pass the specific color for this bar
      );
    });
  }

  /// Configures the main BarChartData, including touch interactions and titles.
  BarChartData mainBarData() {
    return BarChartData(
      barTouchData: BarTouchData(
        touchTooltipData: BarTouchTooltipData(
          getTooltipItem: (group, groupIndex, rod, rodIndex) {
            final label = widget.labels[group.x];
            // Use the helper function to format the duration
            final formattedDuration = _formatDuration(rod.toY);
            return BarTooltipItem(
              '$label\n$formattedDuration',
              const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            );
          },
          getTooltipColor: (_) => Colors.black87, // Tooltip background color
        ),
        touchCallback: (FlTouchEvent event, barTouchResponse) {
          setState(() {
            if (!event.isInterestedForInteractions ||
                barTouchResponse?.spot == null) {
              touchedIndex = -1;
              return;
            }
            touchedIndex = barTouchResponse!.spot!.touchedBarGroupIndex;
          });
        },
      ),
      titlesData: FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 32,
            getTitlesWidget: (value, meta) {
              final index = value.toInt();
              if (index < 0 || index >= widget.labels.length) return const SizedBox();
              return SideTitleWidget(
                meta: meta,
                space: 8,
                child: Text(
                  widget.labels[index],
                  style: const TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            },
          ),
        ),
        leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      ),
      borderData: FlBorderData(show: false),
      barGroups: showingGroups(widget.data),
      gridData: const FlGridData(show: false),
    );
  }
}