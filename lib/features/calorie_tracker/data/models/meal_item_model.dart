import 'package:fitness_app/core/entities/meal_item.dart';

class MealItemModel extends MealItem {
  MealItemModel({
    required super.mealId,
    required super.foodName,
    required super.calories,
    required super.carbs,
    required super.fiber,
    required super.protein,
    required super.quantity,
    required super.sugar,
    required super.unit,
    required super.fat,
  });

  factory MealItemModel.fromJson(Map<String, dynamic> json) {
    return MealItemModel(
      mealId: json['id'],
      foodName: json['name'],
      calories: (json['calories'] as num).toDouble(),
      protein: (json['protein'] as num).toDouble(),
      carbs: (json['carbs'] as num).toDouble(),
      fat: (json['fat'] as num).toDouble(),
      fiber: (json['fiber'] as num).toDouble(),
      sugar: (json['sugar'] as num).toDouble(),
      quantity: (json['quantity'] as num).toInt(),
      unit: json['unit'],
    );
  }
}
