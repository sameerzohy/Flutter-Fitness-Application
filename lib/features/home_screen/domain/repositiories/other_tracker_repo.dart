import 'package:fitness_app/core/error/failure.dart';
import 'package:fpdart/fpdart.dart';

abstract class OtherTrackerRepository {
  Future<Either<Failure, void>> updateWaterTracekr(bool increment);
  Future<Either<Failure, void>> updateSleepTracker(
    DateTime startTime,
    DateTime endTime,
  );
  Future<Either<Failure, void>> updateStepsTracker(bool increment);
  Future<Either<Failure, Map<String, dynamic>>> getSleepsTracker();
  Future<Either<Failure, int>> getStepsTracker();
  Future<Either<Failure, int>> getWaterTracker();
}
