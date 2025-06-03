import 'package:fitness_app/core/entities/meal_combo.dart';
import 'package:fitness_app/core/error/failure.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class SaveMealComboRepository {
  Future<Either<Failure, void>> addMealCombo(SaveMealCombo mealCombo);

  Future<Either<Failure, void>> deleteMealCombo(SaveMealCombo mealCombo);

  Future<Either<Failure, void>> updateMealCombo(SaveMealCombo mealCombo);

  Future<Either<Failure, List<SaveMealCombo>>> getMealcombo();
}
