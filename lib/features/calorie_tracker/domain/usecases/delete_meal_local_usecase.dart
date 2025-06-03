import 'package:fitness_app/core/error/failure.dart';
import 'package:fitness_app/core/usecases/usecase.dart';
import 'package:fitness_app/features/calorie_tracker/domain/repositories/meal_track_local_repository.dart';
import 'package:fpdart/fpdart.dart';

class DeleteMealLocalUsecase implements UseCase<void, DeleteMealTrackParam> {
  final MealTrackLocalRepository _mealTrackLocalRepository;
  const DeleteMealLocalUsecase(this._mealTrackLocalRepository);
  @override
  Future<Either<Failure, void>> call(DeleteMealTrackParam params) async {
    return await _mealTrackLocalRepository.deleteMealItems(
      params.date,
      params.mealTime,
      params.mealId,
    );
  }
}

class DeleteMealTrackParam {
  final DateTime date;
  final String mealTime;
  final String mealId;
  const DeleteMealTrackParam(this.date, this.mealTime, this.mealId);
}
