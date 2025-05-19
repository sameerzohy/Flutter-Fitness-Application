class MealItem {
  final String mealId;
  final String foodName;
  final double calories;
  final double protein;
  final double carbs;
  final double fiber;
  final double sugar;
  final int quantity;
  final double fat;
  final String unit;

  const MealItem({
    required this.mealId,
    required this.foodName,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fiber,
    required this.sugar,
    required this.quantity,
    required this.unit,
    required this.fat,
  });
}
