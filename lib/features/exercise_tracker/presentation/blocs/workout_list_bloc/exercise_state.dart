import 'package:fitness_app/core/entities/workout.dart';


abstract class ExerciseState {}

class ExerciseInitial extends ExerciseState {}

class ExerciseLoading extends ExerciseState {}

class ExerciseLoaded extends ExerciseState {
  final List<Workout> workouts;  // <-- change here from Map to List

  ExerciseLoaded(this.workouts);
}

class ExerciseError extends ExerciseState {
  final String message;

  ExerciseError(this.message);
}
