import 'package:equatable/equatable.dart';
import 'package:fitness_app/features/exercise_tracker/domain/entities/workout_history_entity.dart';


abstract class WorkoutHistoryEvent extends Equatable {
  const WorkoutHistoryEvent();

  @override
  List<Object> get props => [];
}


class LoadWorkoutHistory extends WorkoutHistoryEvent {
  final String exerciseId; // Made non-nullable as it's required for loading
  const LoadWorkoutHistory({required this.exerciseId});
  @override
  List<Object> get props => [exerciseId];
}
class LoadAllWorkoutHistory extends WorkoutHistoryEvent {}

class SaveWorkoutHistoryEvent extends WorkoutHistoryEvent {
  final WorkoutHistoryEntity workout;

  const SaveWorkoutHistoryEvent({required this.workout});

  @override
  List<Object> get props => [workout];
}

class UpdateWorkoutHistoryEvent extends WorkoutHistoryEvent { // Added update event
  final WorkoutHistoryEntity workout;

  const UpdateWorkoutHistoryEvent({required this.workout});

  @override
  List<Object> get props => [workout];
}

class DeleteWorkoutHistoryEvent extends WorkoutHistoryEvent { // Added delete event
  final String exerciseId;
  final String workoutId;

  const DeleteWorkoutHistoryEvent({required this.exerciseId, required this.workoutId});

  @override
  List<Object> get props => [exerciseId, workoutId];
}

class ClearAllWorkoutHistory extends WorkoutHistoryEvent {
  final String exerciseId;

  const ClearAllWorkoutHistory({required this.exerciseId});

  @override
  List<Object> get props => [exerciseId];
}