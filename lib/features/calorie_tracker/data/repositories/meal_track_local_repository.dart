import 'package:fitness_app/core/entities/meal_item.dart';
import 'package:fitness_app/core/error/exception.dart';
import 'package:fitness_app/core/error/failure.dart';
import 'package:fitness_app/features/calorie_tracker/data/local_datasource/local_datasource.dart';
import 'package:fitness_app/features/calorie_tracker/domain/repositories/meal_track_local_repository.dart';
import 'package:fpdart/fpdart.dart';

class MealTrackLocalReposityImpl implements MealTrackLocalRepository {
  final MealTrackLocalDataSource _mealTrackLocalDataSource;
  const MealTrackLocalReposityImpl(this._mealTrackLocalDataSource);
  @override
  Future<Either<Failure, MealItem>> addMealItem(
    MealItem mealItem,
    String mealTime,
    DateTime date,
  ) async {
    try {
      MealItem res = await _mealTrackLocalDataSource.addMealItem(
        mealItem,
        mealTime,
        date,
      );
      return right(res);
    } on ServerException catch (e) {
      return left(Failure(message: e.message));
    } catch (e) {
      return left(Failure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteMealItems(
    DateTime date,
    String mealTime,
    String mealId,
  ) async {
    try {
      await _mealTrackLocalDataSource.deleteMealItems(date, mealTime, mealId);
      return right(null);
    } on ServerException catch (e) {
      return left(Failure(message: e.message));
    } catch (e) {
      return left(Failure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<MealItem>>> getMealItems(
    DateTime date,
    String mealTime,
  ) async {
    try {
      final items = await _mealTrackLocalDataSource.getMealItems(
        date,
        mealTime,
      );
      return right(items);
    } on ServerException catch (e) {
      return left(Failure(message: e.message));
    } catch (e) {
      return left(Failure(message: e.toString()));
    }
  }
}
