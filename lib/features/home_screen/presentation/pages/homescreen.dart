import 'package:fitness_app/features/home_screen/presentation/widgets/horizontal_date_scoller.dart';
import 'package:fitness_app/features/home_screen/presentation/widgets/pie_chart.dart';
import 'package:fitness_app/features/home_screen/presentation/widgets/sleep_tracker.dart';
import 'package:fitness_app/features/home_screen/presentation/widgets/water_tracker.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              NutrientPieChart(),
              SizedBox(height: 30),
              Text('Trackers', style: TextStyle(fontSize: 20)),
              SizedBox(height: 10),
              DateScroller(),
              SizedBox(height: 20),
              WaterTracker(),
              SizedBox(height: 50),
              SleepTracker(),
              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
