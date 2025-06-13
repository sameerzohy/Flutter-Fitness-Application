// lib/features/exercise_tracker/domain/repositories/get_repository.dart

import 'package:fitness_app/core/entities/workout.dart';

abstract class GetRepository {
  Future<List<Workout>> getWorkouts();
}
