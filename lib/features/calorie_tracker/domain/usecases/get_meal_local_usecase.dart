import 'package:fitness_app/core/entities/meal_item.dart';
import 'package:fitness_app/core/error/failure.dart';
import 'package:fitness_app/core/usecases/usecase.dart';
import 'package:fitness_app/features/calorie_tracker/domain/repositories/meal_track_local_repository.dart';
import 'package:fpdart/fpdart.dart';

class GetMealLocalUsecase
    implements UseCase<List<MealItem>, GetMealTrackParam> {
  final MealTrackLocalRepository _mealTrackLocalRepository;
  const GetMealLocalUsecase(this._mealTrackLocalRepository);
  @override
  Future<Either<Failure, List<MealItem>>> call(GetMealTrackParam params) async {
    return await _mealTrackLocalRepository.getMealItems(
      params.date,
      params.mealTime,
    );
  }
}

class GetMealTrackParam {
  final String mealTime;
  final DateTime date;

  GetMealTrackParam({required this.mealTime, required this.date});
}
