import 'package:fitness_app/features/exercise_tracker/domain/usecases/workout_usecases/get_workouts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'exercise_event.dart';
import 'exercise_state.dart';


class ExerciseBloc extends Bloc<ExerciseEvent, ExerciseState> {
  final GetWorkouts getWorkouts;

  ExerciseBloc(this.getWorkouts) : super(ExerciseInitial()) {
    on<LoadWorkoutsEvent>((event, emit) async {
      emit(ExerciseLoading());
      try {
        final workouts = await getWorkouts();
        emit(ExerciseLoaded(workouts));
      } catch (e) {
        emit(ExerciseError("Failed to load workouts"));
      }
    });
  }
}
