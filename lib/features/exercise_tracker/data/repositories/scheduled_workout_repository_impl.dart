// lib/features/exercise_tracker/data/repositories/scheduled_workout_repository_impl.dart
import 'package:fitness_app/core/error/exception.dart';
import 'package:fitness_app/features/exercise_tracker/data/datasources/scheduled_workout_remote_data_source.dart';
import 'package:fitness_app/features/exercise_tracker/domain/entities/scheduled_workout.dart';
import 'package:fpdart/fpdart.dart';
import 'package:fitness_app/core/entities/exercise.dart';

import 'package:fitness_app/core/error/failure.dart';

import 'package:fitness_app/features/exercise_tracker/data/models/scheduled_workout_model2.dart';
import 'package:fitness_app/features/exercise_tracker/domain/repositories/scheduled_workout_repository.dart';

class ScheduledWorkoutRepositoryImpl implements ScheduledWorkoutRepository {
  final ScheduledWorkoutRemoteDataSource remoteDataSource;

  ScheduledWorkoutRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, ScheduledWorkout>> createScheduledWorkout({
    required String title,
    required DateTime dateTime,
    required List<Exercise> exercises,
    required String userId,
  }) async {
    try {
      final scheduledWorkoutModel = ScheduledWorkoutModel(
        title: title,
        dateTime: dateTime,
        exercises: exercises,
        userId: userId,
      );
      final newWorkout = await remoteDataSource.createScheduledWorkout(scheduledWorkoutModel);
      return right(newWorkout);
    } on ServerException catch (e) {
      return left(Failure(message: 'Failed to create scheduled workout: ${e.message}'));
    } catch (e) {
      return left(Failure(message: 'An unexpected error occurred: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, ScheduledWorkout>> updateScheduledWorkout({
    required int id,
    required String title,
    required DateTime dateTime,
    required List<Exercise> exercises,
    required String userId,
  }) async {
    try {
      final scheduledWorkoutModel = ScheduledWorkoutModel(
        id: id,
        title: title,
        dateTime: dateTime,
        exercises: exercises,
        userId: userId,
      );
      final updatedWorkout = await remoteDataSource.updateScheduledWorkout(scheduledWorkoutModel);
      return right(updatedWorkout);
    } on ServerException catch (e) {
      return left(Failure(message: 'Failed to update scheduled workout: ${e.message}'));
    } catch (e) {
      return left(Failure(message: 'An unexpected error occurred: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteScheduledWorkout(int id, String userId) async {
    try {
      await remoteDataSource.deleteScheduledWorkout(id, userId);
      return right(unit);
    } on ServerException catch (e) {
      return left(Failure(message: 'Failed to delete scheduled workout: ${e.message}'));
    } catch (e) {
      return left(Failure(message: 'An unexpected error occurred: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<ScheduledWorkout>>> fetchAllScheduledWorkouts(String userId) async {
    try {
      final workouts = await remoteDataSource.fetchAllScheduledWorkouts(userId);
      return right(workouts);
    } on ServerException catch (e) {
      return left(Failure(message: 'Failed to retrieve scheduled workouts: ${e.message}'));
    } catch (e) {
      return left(Failure(message: 'An unexpected error occurred: ${e.toString()}'));
    }
  }
}