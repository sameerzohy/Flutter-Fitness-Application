// lib/features/exercise_tracker/domain/repositories/exercises_repository.dart
import 'package:fitness_app/core/entities/exercise.dart';

abstract class ExercisesRepository {
  Future<Map<String, List<Exercise>>> loadExercises();
}