import 'package:dartz/dartz.dart';
import 'package:fitness_app/core/error/failure.dart';
import 'package:fitness_app/features/exercise_tracker/data/datasources/workout_local_datasource.dart';
import 'package:fitness_app/features/exercise_tracker/data/datasources/workout_remote_datasource.dart';
import 'package:fitness_app/features/exercise_tracker/data/models/workout_history_model.dart';
import 'package:fitness_app/features/exercise_tracker/domain/entities/workout_history_entity.dart';
import 'package:fitness_app/features/exercise_tracker/domain/repositories/workout_repository.dart';

class WorkoutRepositoryImpl implements WorkoutRepository {
  final WorkoutLocalDataSource localDataSource;
  final WorkoutRemoteDataSource remoteDataSource;

  WorkoutRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, List<WorkoutHistoryEntity>>> loadWorkoutHistory(
    String exerciseId,
  ) async {
    try {
      // Try loading from local first
      final localHistory = await localDataSource.loadWorkoutHistory(exerciseId);
      if (localHistory.isNotEmpty) {
        return Right(localHistory);
      }

      // If local is empty or not found, try remote
      final remoteHistory = await remoteDataSource.loadWorkoutHistory(
        exerciseId,
      );
      // Optionally, sync remote history to local cache here
      // For simplicity, we'll just return remote history if local was empty
      return Right(remoteHistory);
    } on Failure catch (e) {
      // If local fails, try remote
      try {
        final remoteHistory = await remoteDataSource.loadWorkoutHistory(
          exerciseId,
        );
        return Right(remoteHistory);
      } on Failure catch (e) {
        return Left(Failure(message: e.message));
      }
    } on Failure catch (e) {
      return Left(Failure(message: e.message));
    } catch (e) {
      return Left(Failure(message: 'An unexpected error occurred: $e'));
    }
  }

  @override
  Future<Either<Failure, Unit>> saveWorkoutHistory(
    WorkoutHistoryEntity workout,
  ) async {
    try {
      final workoutModel = WorkoutHistoryModel(
        id: workout.id,
        userId: workout.userId,
        exerciseId: workout.exerciseId,
        timestamp: workout.timestamp,
        duration: workout.duration,
        insertedAt: workout.insertedAt,
      );
      await localDataSource.saveWorkoutHistory(
        workout.exerciseId,
        workoutModel,
      );
      await remoteDataSource.saveWorkoutHistory(workoutModel);
      return Right(unit);
    } on Failure catch (e) {
      return Left(Failure(message: e.message));
    } on Failure catch (e) {
      return Left(Failure(message: e.message));
    } catch (e) {
      return Left(Failure(message: 'An unexpected error occurred: $e'));
    }
  }

  @override
  Future<Either<Failure, Unit>> updateWorkoutHistory(
    WorkoutHistoryEntity workout,
  ) async {
    try {
      final workoutModel = WorkoutHistoryModel(
        id: workout.id,
        userId: workout.userId,
        exerciseId: workout.exerciseId,
        timestamp: workout.timestamp,
        duration: workout.duration,
        insertedAt: workout.insertedAt,
      );
      await localDataSource.updateWorkoutHistory(
        workout.exerciseId,
        workoutModel,
      );
      await remoteDataSource.updateWorkoutHistory(workoutModel);
      return Right(unit);
    } on Failure catch (e) {
      return Left(Failure(message: e.message));
    } on Failure catch (e) {
      return Left(Failure(message: e.message));
    } catch (e) {
      return Left(Failure(message: 'An unexpected error occurred: $e'));
    }
  }

  @override
  Future<Either<Failure, List<WorkoutHistoryEntity>>>
  loadAllWorkoutHistory() async {
    try {
      final localHistory = await localDataSource.loadAllWorkoutHistory();
      if (localHistory.isNotEmpty) {
        return Right(localHistory);
      }

      final remoteHistory = await remoteDataSource.loadAllWorkoutHistory();
      return Right(remoteHistory);
    } on Failure catch (e) {
      try {
        final remoteHistory = await remoteDataSource.loadAllWorkoutHistory();
        return Right(remoteHistory);
      } on Failure catch (e) {
        return Left(Failure(message: e.message));
      }
    } on Failure catch (e) {
      return Left(Failure(message: e.message));
    } catch (e) {
      return Left(Failure(message: 'An unexpected error occurred: $e'));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteWorkoutHistory(
    String exerciseId,
    String workoutId,
  ) async {
    try {
      await localDataSource.deleteWorkoutHistory(exerciseId, workoutId);
      await remoteDataSource.deleteWorkoutHistory(
        workoutId,
      ); // Remote only needs workoutId
      return Right(unit);
    } on Failure catch (e) {
      return Left(Failure(message: e.message));
    } on Failure catch (e) {
      return Left(Failure(message: e.message));
    } catch (e) {
      return Left(Failure(message: 'An unexpected error occurred: $e'));
    }
  }

  @override
  Future<Either<Failure, Unit>> clearWorkoutHistory(String exerciseId) async {
    try {
      await localDataSource.clearWorkoutHistory(exerciseId);
      await remoteDataSource.clearWorkoutHistory(exerciseId);
      return Right(unit);
    } on Failure catch (e) {
      return Left(Failure(message: e.message));
    } on Failure catch (e) {
      return Left(Failure(message: e.message));
    } catch (e) {
      return Left(Failure(message: 'An unexpected error occurred: $e'));
    }
  }
}
