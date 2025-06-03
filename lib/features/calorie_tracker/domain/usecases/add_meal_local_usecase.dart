import 'package:fitness_app/core/entities/meal_item.dart';
import 'package:fitness_app/core/error/failure.dart';
import 'package:fitness_app/core/usecases/usecase.dart';
import 'package:fitness_app/features/calorie_tracker/domain/repositories/meal_track_local_repository.dart';
import 'package:fpdart/fpdart.dart';

class AddMealLocalUsecase implements UseCase<MealItem, AddMealTrackParam> {
  final MealTrackLocalRepository _mealTrackLocalRepository;
  const AddMealLocalUsecase(this._mealTrackLocalRepository);
  @override
  Future<Either<Failure, MealItem>> call(AddMealTrackParam params) async {
    return await _mealTrackLocalRepository.addMealItem(
      params.mealItem,
      params.mealTime,
      params.date,
    );
  }
}

class AddMealTrackParam {
  final MealItem mealItem;
  final String mealTime;
  final DateTime date;

  AddMealTrackParam({
    required this.mealItem,
    required this.mealTime,
    required this.date,
  });
}
