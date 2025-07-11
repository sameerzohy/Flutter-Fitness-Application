import 'package:dartz/dartz.dart';

import 'package:fitness_app/core/error/failure.dart';

import 'package:fitness_app/core/usecases/usevcase1.dart';
import 'package:fitness_app/features/exercise_tracker/domain/entities/workout_history_entity.dart';
import 'package:fitness_app/features/exercise_tracker/domain/repositories/workout_repository.dart';

import 'package:equatable/equatable.dart';

class LoadWorkoutHistory
    implements UseCase1<List<WorkoutHistoryEntity>, LoadWorkoutHistoryParams> {
  final WorkoutRepository repository;

  LoadWorkoutHistory(this.repository);

  @override
  Future<Either<Failure, List<WorkoutHistoryEntity>>> call(
    LoadWorkoutHistoryParams params,
  ) async {
    return await repository.loadWorkoutHistory(params.exerciseId);
  }
}

class LoadWorkoutHistoryParams extends Equatable {
  final String exerciseId;

  const LoadWorkoutHistoryParams({required this.exerciseId});

  @override
  List<Object?> get props => [exerciseId];
}
