// lib/features/exercise_tracker/domain/usecases/delete_scheduled_workout.dart
import 'package:equatable/equatable.dart';
import 'package:fitness_app/core/usecases/usecase.dart';
import 'package:fpdart/fpdart.dart';
import 'package:fitness_app/core/error/failure.dart';

import 'package:fitness_app/features/exercise_tracker/domain/repositories/scheduled_workout_repository.dart';

class DeleteScheduledWorkout implements UseCase<void, DeleteWorkoutParams> {
  final ScheduledWorkoutRepository scheduledWorkoutRepository;

  DeleteScheduledWorkout(this.scheduledWorkoutRepository);

  @override
  Future<Either<Failure, void>> call(DeleteWorkoutParams params) async {
    return await scheduledWorkoutRepository.deleteScheduledWorkout(params.id, params.userId);
  }
}

class DeleteWorkoutParams extends Equatable {
  final int id;
  final String userId;

  const DeleteWorkoutParams({required this.id, required this.userId});

  @override
  List<Object?> get props => [id, userId];
}