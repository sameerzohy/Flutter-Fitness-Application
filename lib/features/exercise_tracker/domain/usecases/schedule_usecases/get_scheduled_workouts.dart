// lib/features/exercise_tracker/domain/usecases/fetch_all_scheduled_workouts.dart
import 'package:fitness_app/core/usecases/usecase.dart';
import 'package:fitness_app/features/exercise_tracker/domain/entities/scheduled_workout.dart';
import 'package:fpdart/fpdart.dart';
import 'package:fitness_app/core/error/failure.dart';

import 'package:fitness_app/features/exercise_tracker/domain/repositories/scheduled_workout_repository.dart';

class FetchAllScheduledWorkouts implements UseCase<List<ScheduledWorkout>, String> {
  final ScheduledWorkoutRepository scheduledWorkoutRepository;

  FetchAllScheduledWorkouts(this.scheduledWorkoutRepository);

  @override
  Future<Either<Failure, List<ScheduledWorkout>>> call(String userId) async {
    return await scheduledWorkoutRepository.fetchAllScheduledWorkouts(userId);
  }
}