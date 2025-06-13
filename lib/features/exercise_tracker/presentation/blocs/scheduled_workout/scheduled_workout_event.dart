part of 'scheduled_workout_bloc.dart';

abstract class ScheduledWorkoutEvent with EquatableMixin {
  const ScheduledWorkoutEvent();

  @override
  List<Object> get props => [];
}

class CreateWorkoutEvent extends ScheduledWorkoutEvent {
  final String title;
  final DateTime dateTime;
  final List<Exercise> exercises;
  final String userId;

  const CreateWorkoutEvent({
    required this.title,
    required this.dateTime,
    required this.exercises,
    required this.userId,
  });

  @override
  List<Object> get props => [title, dateTime, exercises, userId];
}

class UpdateWorkoutEvent extends ScheduledWorkoutEvent {
  final int id;
  final String title;
  final DateTime dateTime;
  final List<Exercise> exercises;
  final String userId;

  const UpdateWorkoutEvent({
    required this.id,
    required this.title,
    required this.dateTime,
    required this.exercises,
    required this.userId,
  });

  @override
  List<Object> get props => [id, title, dateTime, exercises, userId];
}

class DeleteWorkoutEvent extends ScheduledWorkoutEvent {
  final int id;
  final String userId;

  const DeleteWorkoutEvent(this.id, this.userId);

  @override
  List<Object> get props => [id, userId];
}

class FetchAllWorkoutsEvent extends ScheduledWorkoutEvent {
  final String userId;

  const FetchAllWorkoutsEvent(this.userId);

  @override
  List<Object> get props => [userId];
}
