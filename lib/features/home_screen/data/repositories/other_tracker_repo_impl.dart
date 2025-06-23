import 'package:fitness_app/core/error/failure.dart';
import 'package:fitness_app/features/home_screen/data/local_datasource/other_track_datasource.dart';
import 'package:fitness_app/features/home_screen/domain/repositiories/other_tracker_repo.dart';
import 'package:fpdart/fpdart.dart';

class OtherTrackerRepositoryImpl extends OtherTrackerRepository {
  final OtherTrackLocalDatasource otherTrackerDatasource;
  OtherTrackerRepositoryImpl({required this.otherTrackerDatasource});

  @override
  Future<Either<Failure, Map<String, dynamic>>> getSleepsTracker() async {
    try {
      final res = await otherTrackerDatasource.getSleepsTracker();
      return right(res);
    } catch (e) {
      return left(Failure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, int>> getStepsTracker() async {
    try {
      final res = await otherTrackerDatasource.getStepsTracker();
      return right(res);
    } catch (e) {
      return left(Failure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, int>> getWaterTracker() async {
    try {
      final res = await otherTrackerDatasource.getWaterTracker();
      return right(res);
    } catch (e) {
      return left(Failure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateSleepTracker(
    DateTime startTime,
    DateTime endTime,
  ) async {
    try {
      await otherTrackerDatasource.updateSleepTracker(startTime, endTime);
      return right(null);
    } catch (e) {
      return left(Failure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateStepsTracker(bool increment) async {
    try {
      await otherTrackerDatasource.updateStepsTracker(increment);
      return right(null);
    } catch (e) {
      return left(Failure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateWaterTracekr(bool increment) async {
    try {
      await otherTrackerDatasource.updateWaterTracekr(increment);
      return right(null);
    } catch (e) {
      return left(Failure(message: e.toString()));
    }
  }
}
