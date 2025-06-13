// lib/features/exercise_tracker/domain/usecases/update_scheduled_workout.dart
import 'package:fitness_app/core/usecases/usecase.dart';
import 'package:fitness_app/features/exercise_tracker/domain/entities/scheduled_workout.dart';
import 'package:fpdart/fpdart.dart';
import 'package:fitness_app/core/entities/exercise.dart';
import 'package:fitness_app/core/error/failure.dart';
import 'package:equatable/equatable.dart';
import 'package:fitness_app/features/exercise_tracker/domain/repositories/scheduled_workout_repository.dart';

class UpdateScheduledWorkout implements UseCase<ScheduledWorkout, UpdateScheduledWorkoutParams> {
  final ScheduledWorkoutRepository scheduledWorkoutRepository;

  UpdateScheduledWorkout(this.scheduledWorkoutRepository);

  @override
  Future<Either<Failure, ScheduledWorkout>> call(UpdateScheduledWorkoutParams params) async {
    return await scheduledWorkoutRepository.updateScheduledWorkout(
      id: params.id,
      title: params.title,
      dateTime: params.dateTime,
      exercises: params.exercises,
      userId: params.userId,
    );
  }
}

class UpdateScheduledWorkoutParams extends Equatable {
  final int id;
  final String title;
  final DateTime dateTime;
  final List<Exercise> exercises;
  final String userId;

  const UpdateScheduledWorkoutParams({
    required this.id,
    required this.title,
    required this.dateTime,
    required this.exercises,
    required this.userId,
  });

  @override
  List<Object?> get props => [id, title, dateTime, exercises, userId];
}