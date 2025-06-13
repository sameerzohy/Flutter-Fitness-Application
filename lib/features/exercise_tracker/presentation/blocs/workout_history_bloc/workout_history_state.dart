import 'package:equatable/equatable.dart';
import 'package:fitness_app/features/exercise_tracker/domain/entities/workout_history_entity.dart';


abstract class WorkoutHistoryState extends Equatable {
  const WorkoutHistoryState();

  @override
  List<Object> get props => [];
}

class WorkoutHistoryInitial extends WorkoutHistoryState {}

class WorkoutHistoryLoading extends WorkoutHistoryState {}

class WorkoutHistoryLoaded extends WorkoutHistoryState {
  final List<WorkoutHistoryEntity> history;

  const WorkoutHistoryLoaded({required this.history});

  @override
  List<Object> get props => [history];
}

class WorkoutHistoryError extends WorkoutHistoryState {
  final String message;

  const WorkoutHistoryError({required this.message});

  @override
  List<Object> get props => [message];
}

class WorkoutHistoryActionSuccess extends WorkoutHistoryState {
  final String message;

  const WorkoutHistoryActionSuccess({required this.message});

  @override
  List<Object> get props => [message];
}