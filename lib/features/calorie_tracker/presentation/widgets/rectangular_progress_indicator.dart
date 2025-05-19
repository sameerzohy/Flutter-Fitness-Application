import 'package:fitness_app/core/theme/appPalatte.dart';
import 'package:flutter/material.dart';

class RectangularGoalTracker extends StatelessWidget {
  final double value; // 0.0 to 1.0
  final String label;
  final String text;

  const RectangularGoalTracker({
    required this.value,
    required this.label,
    required this.text,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: const Color.fromARGB(255, 255, 254, 254),
          ),
        ),
        SizedBox(height: 4),
        LinearProgressIndicator(
          value: value,
          minHeight: 10,
          backgroundColor: Colors.grey.shade300,
          valueColor: AlwaysStoppedAnimation<Color>(AppPallete.TrackerGreen),
          borderRadius: BorderRadius.circular(4),
        ),
        SizedBox(height: 4),
        Text(text, style: TextStyle(color: Colors.white)),
      ],
    );
  }
}
