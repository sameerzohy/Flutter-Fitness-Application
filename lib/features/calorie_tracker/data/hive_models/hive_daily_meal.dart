import 'package:hive/hive.dart';
import 'hive_meal_item.dart';

part 'hive_daily_meal.g.dart';

@HiveType(typeId: 1)
class HiveDailyMeal extends HiveObject {
  @HiveField(0)
  final DateTime date;

  @HiveField(1)
  final String mealType;

  @HiveField(2)
  final List<HiveMealItem> items; // This must be correctly typed

  HiveDailyMeal({
    // required this.userId,
    required this.date,
    required this.mealType,
    required this.items,
  });
}
