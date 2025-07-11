import 'package:fitness_app/core/error/failure.dart';
import 'package:fitness_app/core/usecases/usecase.dart';
import 'package:fitness_app/features/home_screen/data/models/other_tracker_model.dart';
import 'package:fitness_app/features/home_screen/domain/repositiories/get_other_tracker_repo.dart';
import 'package:fpdart/fpdart.dart';

class GetOtherTrackerUsecase implements UseCase<List<OtherTracker>, NoParams> {
  final GetOtherTrackerRepo getOtherTrackerRepo;
  const GetOtherTrackerUsecase({required this.getOtherTrackerRepo});

  @override
  Future<Either<Failure, List<OtherTracker>>> call(NoParams params) async {
    return getOtherTrackerRepo.getOtherTracker();
  }
}
