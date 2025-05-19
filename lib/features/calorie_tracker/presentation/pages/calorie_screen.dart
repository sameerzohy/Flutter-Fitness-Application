import 'package:fitness_app/core/theme/appPalatte.dart';
import 'package:fitness_app/features/calorie_tracker/presentation/widgets/circular_progress_indicator.dart';
import 'package:fitness_app/features/calorie_tracker/presentation/widgets/meal_card.dart';
import 'package:fitness_app/features/calorie_tracker/presentation/widgets/meal_title.dart';
import 'package:fitness_app/features/calorie_tracker/presentation/widgets/rectangular_progress_indicator.dart';
import 'package:flutter/material.dart';

class CalorieScreen extends StatelessWidget {
  const CalorieScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(
          bottom: 20,
          left: 20,
          right: 20,
        ), // Optional
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppPallete.trackerContainerBackground1,
                    AppPallete.trackerContainerBackground2,
                  ],
                ),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 23),
                    child: CircularGoalTracker(value: 0.5, label: 'Calories'),
                  ),
                  const SizedBox(width: 25),
                  Expanded(
                    // this is okay inside a Row, not inside scroll view directly
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RectangularGoalTracker(
                          value: 0.5,
                          label: 'Protein',
                          text: '100g',
                        ),
                        const SizedBox(height: 8),
                        RectangularGoalTracker(
                          value: 0.6,
                          label: 'Carbs',
                          text: '120g',
                        ),
                        const SizedBox(height: 8),
                        RectangularGoalTracker(
                          value: 0.4,
                          label: 'Fat',
                          text: '40g',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),

            Row(
              children: [
                Expanded(
                  child: Card(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        'Saved          Meals',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8), // Optional spacing between cards
                Expanded(
                  child: Card(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        'Calorie Analytics',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
            MealTitle(title: 'BreakFast'),
            const SizedBox(height: 10),
            MealCard(),
            const SizedBox(height: 20),
            MealTitle(title: 'Morning Snack'),
            const SizedBox(height: 10),
            MealCard(),
            const SizedBox(height: 20),
            MealTitle(title: 'Lunch'),
            const SizedBox(height: 10),
            MealCard(),
            const SizedBox(height: 20),
            MealTitle(title: 'Evening Snack'),
            const SizedBox(height: 10),
            MealCard(),
            const SizedBox(height: 20),
            MealTitle(title: 'Dinner'),
            const SizedBox(height: 10),
            MealCard(),
          ],
        ),
      ),
    );
  }
}
