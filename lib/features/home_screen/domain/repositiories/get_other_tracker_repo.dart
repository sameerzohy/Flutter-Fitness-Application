import 'package:fitness_app/core/error/failure.dart';
import 'package:fitness_app/features/home_screen/data/models/other_tracker_model.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class GetOtherTrackerRepo {
  Future<Either<Failure, List<OtherTracker>>> getOtherTracker();
}
