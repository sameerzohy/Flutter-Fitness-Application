// lib/features/exercise_tracker/domain/repositories/scheduled_workout_repository.dart
import 'package:fitness_app/features/exercise_tracker/domain/entities/scheduled_workout.dart';
import 'package:fpdart/fpdart.dart';
import 'package:fitness_app/core/error/failure.dart';

import 'package:fitness_app/core/entities/exercise.dart';

abstract interface class ScheduledWorkoutRepository {
  Future<Either<Failure, ScheduledWorkout>> createScheduledWorkout({
    required String title,
    required DateTime dateTime,
    required List<Exercise> exercises,
    required String userId,
  });
  Future<Either<Failure, ScheduledWorkout>> updateScheduledWorkout({
    required int id,
    required String title,
    required DateTime dateTime,
    required List<Exercise> exercises,
    required String userId,
  });
  Future<Either<Failure, void>> deleteScheduledWorkout(int id, String userId);
  Future<Either<Failure, List<ScheduledWorkout>>> fetchAllScheduledWorkouts(String userId);
}