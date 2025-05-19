import 'dart:convert';
import 'package:fitness_app/features/calorie_tracker/data/models/meal_item_model.dart';
import 'package:flutter/services.dart' show rootBundle;

Future<List<MealItemModel>> loadMealItemsFromAssets() async {
  final String jsonString = await rootBundle.loadString(
    'assets/data/food_details.json',
  );
  final List<dynamic> jsonList = json.decode(jsonString);

  final List<MealItemModel> mealItems = [];

  for (var item in jsonList) {
    // print(item);
    if (item["unit_serving_energy_kcal"] == "") continue;
    double cal = double.parse(item["unit_serving_energy_kcal"]);
    double carb = double.parse(item["unit_serving_carb_g"]);
    double fat = double.parse(item["unit_serving_fat_g"]);
    double fiber = double.parse(item["unit_serving_fibre_g"]);
    double protein = double.parse(item["unit_serving_protein_g"]);
    double sugar = double.parse(item["unit_serving_freesugar_g"]);

    final mealItem = MealItemModel(
      calories: cal,
      carbs: carb,
      fat: fat,
      fiber: fiber,
      protein: protein,
      sugar: sugar,
      foodName: item["food_name"],
      mealId: item["food_code"],
      quantity: 1,
      unit: item["servings_unit"],
    );

    mealItems.add(mealItem);
  }

  return mealItems;
}
