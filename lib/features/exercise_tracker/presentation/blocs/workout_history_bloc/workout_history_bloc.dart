import 'package:fitness_app/core/error/failure.dart';
import 'package:fitness_app/core/usecases/usevcase1.dart';
import 'package:fitness_app/features/exercise_tracker/domain/usecases/workout_usecases/clear_workout_history.dart';
import 'package:fitness_app/features/exercise_tracker/domain/usecases/workout_usecases/delete_workout_history.dart';
import 'package:fitness_app/features/exercise_tracker/domain/usecases/workout_usecases/load_workout_history.dart' as usecase;
import 'package:fitness_app/features/exercise_tracker/domain/usecases/workout_usecases/save_workout_history.dart';
import 'package:fitness_app/features/exercise_tracker/domain/usecases/workout_usecases/update_workout_history.dart';
import 'package:fitness_app/features/exercise_tracker/presentation/blocs/workout_history_bloc/workout_history_event.dart';
import 'package:fitness_app/features/exercise_tracker/presentation/blocs/workout_history_bloc/workout_history_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fitness_app/features/exercise_tracker/domain/usecases/workout_usecases/load_all_workout_history.dart' as usecase1;
class WorkoutHistoryBloc extends Bloc<WorkoutHistoryEvent, WorkoutHistoryState> {
  final usecase.LoadWorkoutHistory loadWorkoutHistoryUseCase;
  final SaveWorkoutHistory saveWorkoutHistoryUseCase;
  final UpdateWorkoutHistory updateWorkoutHistoryUseCase;
  final DeleteWorkoutHistory deleteWorkoutHistoryUseCase;
  final ClearWorkoutHistory clearWorkoutHistoryUseCase;
final usecase1.LoadAllWorkoutHistory loadAllWorkoutHistoryUseCase;

  WorkoutHistoryBloc({
    
    required this.loadWorkoutHistoryUseCase,
    required this.saveWorkoutHistoryUseCase,
     required this.loadAllWorkoutHistoryUseCase,
    required this.updateWorkoutHistoryUseCase,
    required this.deleteWorkoutHistoryUseCase,
    required this.clearWorkoutHistoryUseCase,
  }) : super(WorkoutHistoryInitial()) {
    on<LoadWorkoutHistory>(_onLoadWorkoutHistory);
    on<SaveWorkoutHistoryEvent>(_onSaveWorkoutHistory);
     on<LoadAllWorkoutHistory>(_onLoadAllWorkoutHistory);
    on<UpdateWorkoutHistoryEvent>(_onUpdateWorkoutHistory);
    on<DeleteWorkoutHistoryEvent>(_onDeleteWorkoutHistory);
    on<ClearAllWorkoutHistory>(_onClearAllWorkoutHistory);
  }

  Future<void> _onLoadWorkoutHistory(
    LoadWorkoutHistory event,
    Emitter<WorkoutHistoryState> emit,
  ) async {
    emit(WorkoutHistoryLoading());
    final failureOrHistory = await loadWorkoutHistoryUseCase(
      usecase.LoadWorkoutHistoryParams(exerciseId: event.exerciseId),
    );
    failureOrHistory.fold(
      (failure) => emit(WorkoutHistoryError(message: _mapFailureToMessage(failure))),
      (history) => emit(WorkoutHistoryLoaded(history: history)),
    );
  }

  Future<void> _onLoadAllWorkoutHistory(
    LoadAllWorkoutHistory event,
    Emitter<WorkoutHistoryState> emit,
  ) async {
    emit(WorkoutHistoryLoading());
    final failureOrHistory = await loadAllWorkoutHistoryUseCase(NoParams());
    failureOrHistory.fold(
      (failure) => emit(WorkoutHistoryError(message: _mapFailureToMessage(failure))),
      (history) => emit(WorkoutHistoryLoaded(history: history)),
    );
  }
Future<void> _onSaveWorkoutHistory(
    SaveWorkoutHistoryEvent event,
    Emitter<WorkoutHistoryState> emit,
  ) async {
    if (state is WorkoutHistoryLoaded) {
      emit(WorkoutHistoryLoaded(history: (state as WorkoutHistoryLoaded).history));
    } else {
      emit(WorkoutHistoryLoading());
    }

    final failureOrUnit = await saveWorkoutHistoryUseCase(
      SaveWorkoutHistoryParams(workout: event.workout),
    );
    failureOrUnit.fold(
      (failure) => emit(WorkoutHistoryError(message: _mapFailureToMessage(failure))),
      (_) {
        emit(const WorkoutHistoryActionSuccess(message: 'Workout saved successfully!'));
        add(LoadAllWorkoutHistory());
      },
    );
  }

 Future<void> _onUpdateWorkoutHistory(
    UpdateWorkoutHistoryEvent event,
    Emitter<WorkoutHistoryState> emit,
  ) async {
    if (state is WorkoutHistoryLoaded) {
      emit(WorkoutHistoryLoaded(history: (state as WorkoutHistoryLoaded).history));
    } else {
      emit(WorkoutHistoryLoading());
    }

    final failureOrUnit = await updateWorkoutHistoryUseCase(
      UpdateWorkoutHistoryParams(workout: event.workout),
    );
    failureOrUnit.fold(
      (failure) => emit(WorkoutHistoryError(message: _mapFailureToMessage(failure))),
      (_) {
        emit(const WorkoutHistoryActionSuccess(message: 'Workout updated successfully!'));
        add(LoadAllWorkoutHistory());
      },
    );
  }

  Future<void> _onDeleteWorkoutHistory(
    DeleteWorkoutHistoryEvent event,
    Emitter<WorkoutHistoryState> emit,
  ) async {
    if (state is WorkoutHistoryLoaded) {
      emit(WorkoutHistoryLoaded(history: (state as WorkoutHistoryLoaded).history));
    } else {
      emit(WorkoutHistoryLoading());
    }

    final failureOrUnit = await deleteWorkoutHistoryUseCase(
      DeleteWorkoutHistoryParams(
        exerciseId: event.exerciseId,
        workoutId: event.workoutId,
      ),
    );
    failureOrUnit.fold(
      (failure) => emit(WorkoutHistoryError(message: _mapFailureToMessage(failure))),
      (_) {
        emit(const WorkoutHistoryActionSuccess(message: 'Workout deleted successfully!'));
        add(LoadWorkoutHistory(exerciseId: event.exerciseId));
      },
    );
  }

    Future<void> _onClearAllWorkoutHistory(
    ClearAllWorkoutHistory event,
    Emitter<WorkoutHistoryState> emit,
  ) async {
    if (state is WorkoutHistoryLoaded) {
      emit(WorkoutHistoryLoaded(history: (state as WorkoutHistoryLoaded).history));
    } else {
      emit(WorkoutHistoryLoading());
    }

    final failureOrUnit = await clearWorkoutHistoryUseCase(
      ClearWorkoutHistoryParams(exerciseId: event.exerciseId),
    );
    failureOrUnit.fold(
      (failure) => emit(WorkoutHistoryError(message: _mapFailureToMessage(failure))),
      (_) {
        emit(const WorkoutHistoryActionSuccess(message: 'Workout history cleared!'));
        add(LoadAllWorkoutHistory());
      },
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case Failure:
        return (failure as Failure).message ?? 'Server Error';
      case Failure:
        return (failure as Failure).message ?? 'Cache Error';
      case Failure:
        return (failure as Failure).message ?? 'Network Error';
      default:
        return 'Unexpected Error';
    }
  }
}
