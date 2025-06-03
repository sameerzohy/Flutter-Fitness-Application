import 'package:fitness_app/core/entities/meal_item.dart' show MealItem;
import 'package:fitness_app/core/error/failure.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class MealTrackLocalRepository {
  Future<Either<Failure, MealItem>> addMealItem(
    MealItem mealItem,
    String mealTime,
    DateTime date,
  );
  Future<Either<Failure, List<MealItem>>> getMealItems(
    DateTime date,
    String mealTime,
  );
  Future<Either<Failure, void>> deleteMealItems(
    DateTime date,
    String mealTime,
    String mealId,
  );
}
