import 'package:fitness_app/core/hive/local_user_data.dart';
import 'package:fitness_app/core/theme/appPalatte.dart';
import 'package:fitness_app/features/calorie_tracker/presentation/pages/meal_nutrient_analysis.dart';
import 'package:fitness_app/features/calorie_tracker/presentation/pages/save_meals.dart';
import 'package:fitness_app/features/calorie_tracker/presentation/widgets/circular_progress_indicator.dart';
import 'package:fitness_app/features/calorie_tracker/presentation/widgets/meal_card.dart';
import 'package:fitness_app/features/calorie_tracker/presentation/widgets/meal_title.dart';
import 'package:fitness_app/features/calorie_tracker/presentation/widgets/rectangular_progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fitness_app/features/calorie_tracker/presentation/bloc/meal_track_bloc/meal_track_bloc.dart';
import 'package:fitness_app/core/entities/meal_item.dart';
import 'package:hive/hive.dart';

class CalorieScreen extends StatefulWidget {
  const CalorieScreen({super.key});

  @override
  State<CalorieScreen> createState() => _CalorieScreenState();
}

class _CalorieScreenState extends State<CalorieScreen> {
  @override
  void initState() {
    super.initState();
    final today = DateTime.now();
    final dateOnly = DateTime(today.year, today.month, today.day);
    context.read<MealTrackBloc>().add(GetDailyMeals(date: dateOnly));
  }

  @override
  Widget build(BuildContext context) {
    final userBox = Hive.box<LocalUserData>('userBox');
    final userData = userBox.get('user');
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
        child: BlocBuilder<MealTrackBloc, MealTrackState>(
          builder: (context, state) {
            if (state is GetNutrientInfoFailure ||
                state is GetNutrientInfoSuccess) {
              context.read<MealTrackBloc>().add(
                GetDailyMeals(date: DateTime.now()),
              );
            }
            if (state is GetDailyMealsSuccess) {
              final Map<String, List<MealItem>> allMeals =
                  state.mealsByCategory;
              final meals = allMeals['all_meals']!;
              final totalCalories = meals.fold<double>(
                0,
                (sum, item) => sum + item.calories,
              );
              final totalCarbs = meals.fold<double>(
                0,
                (sum, item) => sum + item.carbs,
              );
              final totalProtein = meals.fold<double>(
                0,
                (sum, item) => sum + item.protein,
              );
              final totalFat = meals.fold<double>(
                0,
                (sum, item) => sum + item.fat,
              );

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nutrient Summary
                  Container(
                    padding: const EdgeInsets.all(20),
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
                          child: CircularGoalTracker(
                            value:
                                totalCalories /
                                (userData?.goalCalories ??
                                    2000), // fallback if null
                            label: 'Calories',
                          ),
                        ),
                        const SizedBox(width: 25),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RectangularGoalTracker(
                                value:
                                    totalProtein /
                                    (userData?.goalProtein ?? 150),
                                label: 'Protein',
                                text: '${totalProtein.toStringAsFixed(0)}g',
                              ),
                              const SizedBox(height: 8),
                              RectangularGoalTracker(
                                value:
                                    totalCarbs / (userData?.goalCarbs ?? 250),
                                label: 'Carbs',
                                text: '${totalCarbs.toStringAsFixed(0)}g',
                              ),
                              const SizedBox(height: 8),
                              RectangularGoalTracker(
                                value: totalFat / (userData?.goalFat ?? 70),
                                label: 'Fat',
                                text: '${totalFat.toStringAsFixed(0)}g',
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),
                  // Quick Access Cards
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (cxt) => SaveMealsRemote(),
                              ),
                            );
                          },
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text(
                                'Saved          Meals',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => const MealNutrientAnalysis(),
                              ),
                            );
                          },
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text(
                                'Calorie Analysis',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 40),

                  // Meal Sections
                  ...[
                    'BreakFast',
                    'Morning Snack',
                    'Lunch',
                    'Evening Snack',
                    'Dinner',
                  ].map(
                    (mealTime) => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        MealTitle(title: mealTime),
                        const SizedBox(height: 10),
                        MealCard(mealTime: mealTime, allMeals: allMeals),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ],
              );
            } else if (state is GetMealFailure) {
              return Center(
                child: Text('Failed to load meals: ${state.message}'),
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}
