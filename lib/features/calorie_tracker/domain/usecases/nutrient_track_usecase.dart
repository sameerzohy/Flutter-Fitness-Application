import 'package:fitness_app/core/error/failure.dart';
import 'package:fitness_app/core/usecases/usecase.dart';
import 'package:fitness_app/features/calorie_tracker/domain/repositories/nutrient_track_repo.dart';
import 'package:fpdart/fpdart.dart';

class NutrientTrackUsecase
    implements UseCase<Map<DateTime, Map<String, dynamic>>, NoParams> {
  final NutrientTrackRepository nutrientTrackRepository;
  const NutrientTrackUsecase(this.nutrientTrackRepository);

  @override
  Future<Either<Failure, Map<DateTime, Map<String, dynamic>>>> call(
    NoParams params,
  ) async {
    return await nutrientTrackRepository.fetchMealDataForWeek();
  }
}
