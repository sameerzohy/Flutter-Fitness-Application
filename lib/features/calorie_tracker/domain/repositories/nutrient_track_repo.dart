import 'package:fitness_app/core/error/failure.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class NutrientTrackRepository {
  Future<Either<Failure, Map<DateTime, Map<String, dynamic>>>>
  fetchMealDataForWeek();
}
