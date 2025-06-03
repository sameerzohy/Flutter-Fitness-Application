import 'package:fitness_app/core/entities/meal_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fitness_app/features/calorie_tracker/presentation/bloc/meal_track_bloc/meal_track_bloc.dart';

class MealCard extends StatelessWidget {
  final String mealTime;
  final Map<String, List<MealItem>> allMeals;

  const MealCard({super.key, required this.mealTime, required this.allMeals});

  @override
  Widget build(BuildContext context) {
    final meals = allMeals[mealTime]!;

    return Card(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(15),
        child:
            meals.isEmpty
                ? Text('No meals for $mealTime')
                : ListView.builder(
                  itemCount: meals.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final meal = meals[index];
                    return ListTile(
                      title: Text(meal.foodName),
                      subtitle: Text(
                        '${meal.calories.toStringAsFixed(2)} kcal • ${meal.quantity} No',
                        style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          final today = DateTime.now();
                          final dateOnly = DateTime(
                            today.year,
                            today.month,
                            today.day,
                          );

                          context.read<MealTrackBloc>().add(
                            DeleteMealLocal(
                              date: dateOnly,
                              mealTime: mealTime,
                              mealId: meal.mealId,
                            ),
                          );

                          // Re-fetch all daily meals to keep UI consistent
                          // context.read<MealTrackBloc>().add(
                          //   GetDailyMeals(date: dateOnly),
                          // );
                        },
                      ),
                    );
                  },
                ),
      ),
    );
  }
}
