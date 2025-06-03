import 'package:fitness_app/features/calorie_tracker/data/models/meal_item_model.dart';

class SaveMealCombo {
  String mealId;
  String mealComboName;
  List<MealItemModel> meals;

  SaveMealCombo({
    required this.mealId,
    required this.mealComboName,
    required this.meals,
  });

  Map<String, dynamic> toJson(String userId) {
    return {
      'id': mealId,
      'user_id': userId,
      'name': mealComboName,
      'meals_json': meals.map((meal) => meal.toJson()).toList(),
    };
  }
}
