// lib/features/exercise_tracker/presentation/blocs/scheduled_workout/scheduled_workout_state.dart
part of 'scheduled_workout_bloc.dart';

sealed class ScheduledWorkoutState extends Equatable {
  const ScheduledWorkoutState();

  @override
  List<Object> get props => [];
}

final class ScheduledWorkoutInitial extends ScheduledWorkoutState {}

final class ScheduledWorkoutLoading extends ScheduledWorkoutState {}

final class ScheduledWorkoutFailure extends ScheduledWorkoutState {
  final String message;
  const ScheduledWorkoutFailure(this.message);

  @override
  List<Object> get props => [message];
}

final class ScheduledWorkoutSuccess extends ScheduledWorkoutState {
  final ScheduledWorkout scheduledWorkout;
  const ScheduledWorkoutSuccess(this.scheduledWorkout);

  @override
  List<Object> get props => [scheduledWorkout];
}

final class ScheduledWorkoutDeleteSuccess extends ScheduledWorkoutState {
  const ScheduledWorkoutDeleteSuccess();
}

final class ScheduledWorkoutsDisplaySuccess extends ScheduledWorkoutState {
  final List<ScheduledWorkout> scheduledWorkouts;
  const ScheduledWorkoutsDisplaySuccess(this.scheduledWorkouts);

  @override
  List<Object> get props => [scheduledWorkouts];
}