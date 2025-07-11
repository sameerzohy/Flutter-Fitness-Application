import 'package:dartz/dartz.dart';

import 'package:fitness_app/core/error/failure.dart';

import 'package:fitness_app/core/usecases/usevcase1.dart';
import 'package:fitness_app/features/exercise_tracker/domain/entities/workout_history_entity.dart';
import 'package:fitness_app/features/exercise_tracker/domain/repositories/workout_repository.dart';

import 'package:equatable/equatable.dart';

class UpdateWorkoutHistory
    implements UseCase1<Unit, UpdateWorkoutHistoryParams> {
  final WorkoutRepository repository;

  UpdateWorkoutHistory(this.repository);

  @override
  Future<Either<Failure, Unit>> call(UpdateWorkoutHistoryParams params) async {
    return await repository.updateWorkoutHistory(params.workout);
  }
}

class UpdateWorkoutHistoryParams extends Equatable {
  final WorkoutHistoryEntity workout;

  const UpdateWorkoutHistoryParams({required this.workout});

  @override
  List<Object?> get props => [workout];
}
