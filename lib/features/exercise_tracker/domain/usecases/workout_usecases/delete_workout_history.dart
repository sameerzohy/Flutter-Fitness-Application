import 'package:dartz/dartz.dart';

import 'package:dartz/dartz.dart';
import 'package:fitness_app/core/error/failure.dart';

import 'package:fitness_app/core/usecases/usecase.dart';
import 'package:fitness_app/core/usecases/usevcase1.dart';
import 'package:fitness_app/features/exercise_tracker/domain/entities/workout_history_entity.dart';
import 'package:fitness_app/features/exercise_tracker/domain/repositories/workout_repository.dart';

import 'package:equatable/equatable.dart';


class DeleteWorkoutHistory implements UseCase1<Unit, DeleteWorkoutHistoryParams> {
  final WorkoutRepository repository;

  DeleteWorkoutHistory(this.repository);

  @override
  Future<Either<Failure, Unit>> call(DeleteWorkoutHistoryParams params) async {
    return await repository.deleteWorkoutHistory(params.exerciseId, params.workoutId);
  }
}

class DeleteWorkoutHistoryParams extends Equatable {
  final String exerciseId;
  final String workoutId;

  const DeleteWorkoutHistoryParams({required this.exerciseId, required this.workoutId});

  @override
  List<Object?> get props => [exerciseId, workoutId];
}
