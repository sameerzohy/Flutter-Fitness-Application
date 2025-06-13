// lib/features/exercise_tracker/domain/usecases/create_scheduled_workout.dart
import 'package:fitness_app/core/usecases/usecase.dart';
import 'package:fitness_app/features/exercise_tracker/domain/entities/scheduled_workout.dart';
import 'package:fpdart/fpdart.dart';
import 'package:fitness_app/core/entities/exercise.dart';
import 'package:fitness_app/core/error/failure.dart';

import 'package:equatable/equatable.dart';

import 'package:fitness_app/features/exercise_tracker/domain/repositories/scheduled_workout_repository.dart';

class CreateScheduledWorkout implements UseCase<ScheduledWorkout, CreateScheduledWorkoutParams> {
  final ScheduledWorkoutRepository scheduledWorkoutRepository;

  CreateScheduledWorkout(this.scheduledWorkoutRepository);

  @override
  Future<Either<Failure, ScheduledWorkout>> call(CreateScheduledWorkoutParams params) async {
    return await scheduledWorkoutRepository.createScheduledWorkout(
      title: params.title,
      dateTime: params.dateTime,
      exercises: params.exercises,
      userId: params.userId,
    );
  }
}

class CreateScheduledWorkoutParams extends Equatable {
  final String title;
  final DateTime dateTime;
  final List<Exercise> exercises;
  final String userId;

  const CreateScheduledWorkoutParams({
    required this.title,
    required this.dateTime,
    required this.exercises,
    required this.userId,
  });

  @override
  List<Object?> get props => [title, dateTime, exercises, userId];
}