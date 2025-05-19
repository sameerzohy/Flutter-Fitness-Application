import 'package:fitness_app/core/theme/appPalatte.dart';
import 'package:flutter/material.dart';

class CircularGoalTracker extends StatelessWidget {
  final double value; // e.g. 0.6
  final String label;
  final String unit;

  const CircularGoalTracker({
    required this.value,
    required this.label,
    this.unit = '',
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          height: 150,
          width: 150,
          child: CircularProgressIndicator(
            value: value, // e.g., 0.75
            strokeWidth: 12,
            strokeCap: StrokeCap.round,
            backgroundColor: Colors.grey.shade300,
            valueColor: AlwaysStoppedAnimation<Color>(AppPallete.TrackerGreen),
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${(value * 100).toInt()}%',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.white,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
