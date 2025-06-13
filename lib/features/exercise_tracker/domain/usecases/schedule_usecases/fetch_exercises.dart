// lib/features/exercise_tracker/domain/usecases/fetch_exercises.dart
import 'package:fitness_app/core/usecases/usecase.dart';
import 'package:fpdart/fpdart.dart';
import 'package:fitness_app/core/entities/exercise.dart';
import 'package:fitness_app/core/error/failure.dart';

import 'package:fitness_app/features/exercise_tracker/domain/repositories/exercises_repository.dart';

class FetchExercises implements UseCase<Map<String, List<Exercise>>, NoParams> {
  final ExercisesRepository repository;

  FetchExercises(this.repository);

  @override
  Future<Either<Failure, Map<String, List<Exercise>>>> call(NoParams params) async {
    try {
      final result = await repository.loadExercises();
      return right(result);
    } catch (e) {
      return left(Failure(message: 'Failed to load exercises: ${e.toString()}'));
    }
  }
}