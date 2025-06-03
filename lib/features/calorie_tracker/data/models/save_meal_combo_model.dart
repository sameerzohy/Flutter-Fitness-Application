import 'package:fitness_app/core/entities/meal_combo.dart';
import 'package:fitness_app/features/calorie_tracker/data/models/meal_item_model.dart';

class SaveMealComboModel extends SaveMealCombo {
  SaveMealComboModel({
    required super.mealId,
    required super.mealComboName,
    required super.meals,
  });

  factory SaveMealComboModel.fromJson(Map<String, dynamic> json) {
    return SaveMealComboModel(
      mealId: json['id'],
      mealComboName: json['name'],
      meals:
          (json['meals_json'] as List)
              .map((item) => MealItemModel.fromJson(item))
              .toList(),
    );
  }
}
