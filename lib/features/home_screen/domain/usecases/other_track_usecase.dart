import 'package:fitness_app/core/error/failure.dart';
import 'package:fitness_app/core/usecases/usecase.dart';
import 'package:fitness_app/features/home_screen/domain/repositiories/other_tracker_repo.dart';
import 'package:fpdart/fpdart.dart';

class UpdateWaterTrackerUsecase implements UseCase<void, WaterTrackerParams> {
  final OtherTrackerRepository otherTrackerRepository;

  const UpdateWaterTrackerUsecase({required this.otherTrackerRepository});
  @override
  Future<Either<Failure, void>> call(WaterTrackerParams params) {
    return otherTrackerRepository.updateWaterTracekr(params.isIncrement);
  }
}

class GetWaterTrackerUsecase implements UseCase<int, NoParams> {
  final OtherTrackerRepository otherTrackerRepository;
  const GetWaterTrackerUsecase({required this.otherTrackerRepository});

  @override
  Future<Either<Failure, int>> call(NoParams params) {
    return otherTrackerRepository.getWaterTracker();
  }
}

class WaterTrackerParams {
  final bool isIncrement;

  WaterTrackerParams({required this.isIncrement});
}

class UpdateSleepUsecase implements UseCase<void, UpdateSleepParams> {
  final OtherTrackerRepository otherTrackerRepository;
  const UpdateSleepUsecase({required this.otherTrackerRepository});
  @override
  Future<Either<Failure, void>> call(UpdateSleepParams params) async {
    return await otherTrackerRepository.updateSleepTracker(
      params.startTime,
      params.endTime,
    );
  }
}

class UpdateSleepParams {
  final DateTime startTime;
  final DateTime endTime;

  UpdateSleepParams({required this.startTime, required this.endTime});
}

class GetSleepTrackerUsecase
    implements UseCase<Map<String, dynamic>, NoParams> {
  final OtherTrackerRepository otherTrackerRepository;
  const GetSleepTrackerUsecase({required this.otherTrackerRepository});

  @override
  Future<Either<Failure, Map<String, dynamic>>> call(NoParams params) async {
    return await otherTrackerRepository.getSleepsTracker();
  }
}
