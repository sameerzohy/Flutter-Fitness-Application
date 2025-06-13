// lib/features/exercise_tracker/presentation/blocs/scheduled_workout/scheduled_workout_bloc.dart
import 'package:bloc/bloc.dart';
import 'package:fitness_app/core/entities/exercise.dart';
import 'package:fitness_app/features/exercise_tracker/domain/entities/scheduled_workout.dart';


import 'package:fitness_app/features/exercise_tracker/domain/usecases/schedule_usecases/create_scheduled_workout.dart';
import 'package:fitness_app/features/exercise_tracker/domain/usecases/schedule_usecases/delete_scheduled_workout.dart';
import 'package:fitness_app/features/exercise_tracker/domain/usecases/schedule_usecases/get_scheduled_workouts.dart';
import 'package:fitness_app/features/exercise_tracker/domain/usecases/schedule_usecases/update_scheduled_workout.dart';

import 'package:equatable/equatable.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

part 'scheduled_workout_event.dart';
part 'scheduled_workout_state.dart';

class ScheduledWorkoutBloc extends Bloc<ScheduledWorkoutEvent, ScheduledWorkoutState> {
  final CreateScheduledWorkout _createScheduledWorkout;
  final UpdateScheduledWorkout _updateScheduledWorkout;
  final DeleteScheduledWorkout _deleteScheduledWorkout;
  final FetchAllScheduledWorkouts _fetchAllScheduledWorkouts;
  final SupabaseClient _supabaseClient;

  ScheduledWorkoutBloc({
    required CreateScheduledWorkout createScheduledWorkout,
    required UpdateScheduledWorkout updateScheduledWorkout,
    required DeleteScheduledWorkout deleteScheduledWorkout,
    required FetchAllScheduledWorkouts fetchAllScheduledWorkouts,
    required SupabaseClient supabaseClient,
  })  : _createScheduledWorkout = createScheduledWorkout,
        _updateScheduledWorkout = updateScheduledWorkout,
        _deleteScheduledWorkout = deleteScheduledWorkout,
        _fetchAllScheduledWorkouts = fetchAllScheduledWorkouts,
        _supabaseClient = supabaseClient,
        super(ScheduledWorkoutInitial()) {
    on<CreateWorkoutEvent>(_onCreateWorkout);
    on<UpdateWorkoutEvent>(_onUpdateWorkout);
    on<DeleteWorkoutEvent>(_onDeleteWorkout);
    on<FetchAllWorkoutsEvent>(_onFetchAllWorkouts);
  }

  String? get _currentUserId => _supabaseClient.auth.currentUser?.id;

  void _onCreateWorkout(CreateWorkoutEvent event, Emitter<ScheduledWorkoutState> emit) async {
    if (_currentUserId == null) {
      return emit(const ScheduledWorkoutFailure('User not authenticated. Please log in.'));
    }
    emit(ScheduledWorkoutLoading());
    final res = await _createScheduledWorkout(
      CreateScheduledWorkoutParams(
        title: event.title,
        dateTime: event.dateTime,
        exercises: event.exercises,
        userId: _currentUserId!,
      ),
    );

    res.fold(
      (failure) => emit(ScheduledWorkoutFailure(failure.message)),
      (scheduledWorkout) => emit(ScheduledWorkoutSuccess(scheduledWorkout)),
    );
  }

  void _onUpdateWorkout(UpdateWorkoutEvent event, Emitter<ScheduledWorkoutState> emit) async {
    if (_currentUserId == null) {
      return emit(const ScheduledWorkoutFailure('User not authenticated. Please log in.'));
    }
    emit(ScheduledWorkoutLoading());
    final res = await _updateScheduledWorkout(
      UpdateScheduledWorkoutParams(
        id: event.id,
        title: event.title,
        dateTime: event.dateTime,
        exercises: event.exercises,
        userId: _currentUserId!,
      ),
    );

    res.fold(
      (failure) => emit(ScheduledWorkoutFailure(failure.message)),
      (scheduledWorkout) => emit(ScheduledWorkoutSuccess(scheduledWorkout)),
    );
  }

  void _onDeleteWorkout(DeleteWorkoutEvent event, Emitter<ScheduledWorkoutState> emit) async {
    if (_currentUserId == null) {
      return emit(const ScheduledWorkoutFailure('User not authenticated. Please log in.'));
    }
    emit(ScheduledWorkoutLoading());
    final res = await _deleteScheduledWorkout(
      DeleteWorkoutParams(id: event.id, userId: _currentUserId!),
    );

    res.fold(
      (failure) => emit(ScheduledWorkoutFailure(failure.message)),
      (_) => emit(const ScheduledWorkoutDeleteSuccess()),
    );
  }

  void _onFetchAllWorkouts(FetchAllWorkoutsEvent event, Emitter<ScheduledWorkoutState> emit) async {
    if (event.userId.isEmpty) {
      return emit(const ScheduledWorkoutFailure('User ID is missing for fetching workouts.'));
    }
    emit(ScheduledWorkoutLoading());
    final res = await _fetchAllScheduledWorkouts(event.userId);

    res.fold(
      (failure) => emit(ScheduledWorkoutFailure(failure.message)),
      (workouts) => emit(ScheduledWorkoutsDisplaySuccess(workouts)),
    );
  }
}