import 'package:fitness_app/core/error/failure.dart';
import 'package:fitness_app/features/home_screen/data/models/other_tracker_model.dart';
import 'package:fitness_app/features/home_screen/data/remote_datasource/get_other_tracker.dart';
import 'package:fitness_app/features/home_screen/domain/repositiories/get_other_tracker_repo.dart';
import 'package:fpdart/fpdart.dart';

class GetOtherTrakerRepoImpl implements GetOtherTrackerRepo {
  final GetOtherTracker remoteTracker;

  GetOtherTrakerRepoImpl({required this.remoteTracker});
  @override
  Future<Either<Failure, List<OtherTracker>>> getOtherTracker() async {
    try {
      final res = await remoteTracker.getOtherTracker();
      return right(res);
    } catch (e) {
      return left(Failure(message: e.toString()));
    }
  }
}
