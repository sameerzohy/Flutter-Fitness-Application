import 'package:dartz/dartz.dart';
import 'package:fitness_app/core/error/failure.dart';

import 'package:fitness_app/features/exercise_tracker/domain/entities/workout_history_entity.dart';


abstract class WorkoutRepository {
  Future<Either<Failure, List<WorkoutHistoryEntity>>> loadWorkoutHistory(String exerciseId);
  Future<Either<Failure, Unit>> saveWorkoutHistory(WorkoutHistoryEntity workout);
  Future<Either<Failure, Unit>> updateWorkoutHistory(WorkoutHistoryEntity workout); 
    Future<Either<Failure, List<WorkoutHistoryEntity>>> loadAllWorkoutHistory();// Added update
  Future<Either<Failure, Unit>> deleteWorkoutHistory(String exerciseId, String workoutId); // Added delete individual
  Future<Either<Failure, Unit>> clearWorkoutHistory(String exerciseId);
}