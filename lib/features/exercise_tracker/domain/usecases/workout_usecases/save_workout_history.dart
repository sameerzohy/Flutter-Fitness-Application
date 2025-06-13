import 'package:dartz/dartz.dart';
import 'package:fitness_app/core/error/failure.dart';

import 'package:fitness_app/core/usecases/usecase.dart';
import 'package:fitness_app/core/usecases/usevcase1.dart';
import 'package:fitness_app/features/exercise_tracker/domain/entities/workout_history_entity.dart';
import 'package:fitness_app/features/exercise_tracker/domain/repositories/workout_repository.dart';

import 'package:equatable/equatable.dart';

class SaveWorkoutHistory implements UseCase1<Unit, SaveWorkoutHistoryParams> {
  final WorkoutRepository repository;

  SaveWorkoutHistory(this.repository);

  @override
  Future<Either<Failure, Unit>> call(SaveWorkoutHistoryParams params) async {
    return await repository.saveWorkoutHistory(params.workout);
  }
}

class SaveWorkoutHistoryParams extends Equatable {
  final WorkoutHistoryEntity workout;

  const SaveWorkoutHistoryParams({required this.workout});

  @override
  List<Object?> get props => [workout];
}