import 'package:fitness_app/features/home_screen/presentation/widgets/horizontal_date_scoller.dart';
import 'package:fitness_app/features/home_screen/presentation/widgets/pie_chart.dart';
import 'package:fitness_app/features/home_screen/presentation/widgets/sleep_tracker.dart';
import 'package:fitness_app/features/home_screen/presentation/widgets/water_tracker.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              NutrientPieChart(),
              SizedBox(height: 20),
              WaterTracker(),
              SizedBox(height: 30),
              DateScroller(),
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
