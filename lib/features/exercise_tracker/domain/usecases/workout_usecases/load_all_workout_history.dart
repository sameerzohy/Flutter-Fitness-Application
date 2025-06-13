import 'package:dartz/dartz.dart';
import 'package:fitness_app/core/error/failure.dart';


import 'package:fitness_app/core/usecases/usevcase1.dart';
import 'package:fitness_app/features/exercise_tracker/domain/entities/workout_history_entity.dart';

import 'package:fitness_app/features/exercise_tracker/domain/repositories/workout_repository.dart';

class LoadAllWorkoutHistory implements UseCase1<List<WorkoutHistoryEntity>, NoParams> {
  final WorkoutRepository repository;

  LoadAllWorkoutHistory(this.repository);

  @override
  Future<Either<Failure, List<WorkoutHistoryEntity>>> call(NoParams params) async {
    return await repository.loadAllWorkoutHistory();
  }
}