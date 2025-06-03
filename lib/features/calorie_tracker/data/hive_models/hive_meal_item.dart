import 'package:hive/hive.dart';

part 'hive_meal_item.g.dart';

@HiveType(typeId: 2)
class HiveMealItem extends HiveObject {
  @HiveField(0)
  String id; // ← Unique ID

  @HiveField(1)
  String foodName;

  @HiveField(2)
  double calories;

  @HiveField(3)
  double protein;

  @HiveField(4)
  double carbs;

  @HiveField(5)
  double fat;

  @HiveField(6)
  double fibre;

  @HiveField(7)
  double sugar;

  @HiveField(8)
  double quantity;

  @HiveField(9)
  String unit;

  @HiveField(10)
  String? notes;

  HiveMealItem({
    required this.id,
    required this.foodName,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.fibre,
    required this.sugar,
    required this.quantity,
    required this.unit,
    this.notes,
  });
}
