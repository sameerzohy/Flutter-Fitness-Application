import 'package:fitness_app/core/entities/meal_combo.dart';
import 'package:fitness_app/core/error/failure.dart';
import 'package:fitness_app/features/calorie_tracker/data/remotedatasources/save_meal_combo_remote.dart';
import 'package:fitness_app/features/calorie_tracker/domain/repositories/save_meal_combo.dart';
import 'package:fpdart/fpdart.dart';

class SaveMealComboRepositoryImpl implements SaveMealComboRepository {
  final SaveMealComboRemote saveMealComboRemote;

  const SaveMealComboRepositoryImpl({required this.saveMealComboRemote});

  @override
  Future<Either<Failure, void>> addMealCombo(SaveMealCombo mealCombo) async {
    try {
      await saveMealComboRemote.addMealCombo(mealCombo);
      return right(null);
    } catch (e) {
      return left(Failure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteMealCombo(SaveMealCombo mealCombo) async {
    try {
      await saveMealComboRemote.deleteMealCombo(mealCombo);
      return right(null);
    } catch (e) {
      return left(Failure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<SaveMealCombo>>> getMealcombo() async {
    try {
      return right(await saveMealComboRemote.getMealcombo());
    } catch (e) {
      return left(Failure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateMealCombo(SaveMealCombo mealCombo) async {
    try {
      await saveMealComboRemote.updateMealCombo(mealCombo);
      return right(null);
    } catch (e) {
      return left(Failure(message: e.toString()));
    }
  }
}
