import 'package:fitness_app/core/entities/meal_combo.dart';
import 'package:fitness_app/core/entities/meal_item.dart';
import 'package:fitness_app/core/utilities/meal_parser.dart';
import 'package:fitness_app/features/calorie_tracker/presentation/bloc/meal_utility_bloc/meal_utilities_bloc.dart';
import 'package:fitness_app/features/calorie_tracker/presentation/pages/meal_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchMealPage extends StatefulWidget {
  final String mealTime;
  final List<MealItem> meals;
  const SearchMealPage({
    super.key,
    required this.mealTime,
    required this.meals,
  });

  @override
  State<SearchMealPage> createState() => _SearchMealPageState();
}

class _SearchMealPageState extends State<SearchMealPage> {
  List<MealItem> allMeals = [];
  List<MealItem> filteredMeals = [];
  String query = '';
  List<MealItem> fromSaved = [];

  @override
  void initState() {
    super.initState();
    context.read<MealUtilitiesBloc>().add(GetMealComboEvent());
    loadMealItemsFromAssets().then((meals) {
      setState(() {
        allMeals = meals;
        filteredMeals = fromSaved;
      });
    });
  }

  List<MealItem> convertToMealItem(List<SaveMealCombo> saved) {
    List<MealItem> items = [];

    for (var savedItem in saved) {
      double calories = 0;
      double fat = 0;
      double carbs = 0;
      double protein = 0;
      double fiber = 0;
      double sugar = 0;
      for (var meal in savedItem.meals) {
        calories += meal.calories;
        fat += meal.fat;
        carbs += meal.carbs;
        protein += meal.protein;
        fiber += meal.fiber;
        sugar += meal.sugar;
      }
      items.add(
        MealItem(
          mealId: savedItem.mealId,
          foodName: savedItem.mealComboName,
          calories: calories,
          fat: fat,
          carbs: carbs,
          protein: protein,
          fiber: fiber,
          sugar: sugar,
          quantity: 1,
          unit: 'No',
        ),
      );
    }
    return items;
  }

  void updateSearch(String input) {
    if (input.isEmpty) {
      query = '';
      setState(() => filteredMeals = fromSaved);
      return;
    }
    setState(() {
      query = input.toLowerCase();
      filteredMeals =
          allMeals.where((meal) {
            return meal.foodName.toLowerCase().contains(query);
          }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    print(query);
    return Scaffold(
      appBar: AppBar(title: const Text('Search Meals')),
      body: Column(
        children: [
          BlocBuilder<MealUtilitiesBloc, MealUtilitiesState>(
            builder: (context, state) {
              if (state is GetMealComboSuccess) {
                fromSaved = convertToMealItem(state.savedMeals);
              }
              return Padding(
                padding: const EdgeInsets.all(12.0),
                child: TextField(
                  onChanged: updateSearch,
                  decoration: InputDecoration(
                    hintText: 'Search for meals...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              );
            },
          ),
          if (query == '' || query.isEmpty && fromSaved.isNotEmpty)
            const Text(
              'Your Saved Meals',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          Expanded(
            child:
                filteredMeals.isEmpty
                    ? const Center(child: Text('No meals found.'))
                    : ListView.builder(
                      itemCount: filteredMeals.length,
                      itemBuilder: (context, index) {
                        final meal = filteredMeals[index];
                        return ListTile(
                          title: Text(meal.foodName),
                          subtitle: Text('${meal.calories} kcal'),
                          trailing: const Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (_) => MealDetailPage(
                                      meal: meal,
                                      mealTime: widget.mealTime,
                                      meals: widget.meals,
                                    ),
                              ),
                            );
                          },
                        );
                      },
                    ),
          ),
        ],
      ),
    );
  }
}
