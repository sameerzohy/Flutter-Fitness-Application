import 'package:dartz/dartz.dart';
import 'package:fitness_app/core/error/failure.dart';

import 'package:fitness_app/core/usecases/usecase.dart';
import 'package:fitness_app/core/usecases/usevcase1.dart';
import 'package:fitness_app/features/exercise_tracker/domain/repositories/workout_repository.dart';

import 'package:equatable/equatable.dart';

class ClearWorkoutHistory implements UseCase1<Unit, ClearWorkoutHistoryParams> {
  final WorkoutRepository repository;

  ClearWorkoutHistory(this.repository);

  @override
  Future<Either<Failure, Unit>> call(ClearWorkoutHistoryParams params) async {
    return await repository.clearWorkoutHistory(params.exerciseId);
  }
}

class ClearWorkoutHistoryParams extends Equatable {
  final String exerciseId;

  const ClearWorkoutHistoryParams({required this.exerciseId});

  @override
  List<Object?> get props => [exerciseId];
}
