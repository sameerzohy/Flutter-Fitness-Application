import 'package:fitness_app/core/entities/workout.dart';
import 'package:fitness_app/features/exercise_tracker/domain/repositories/GetWorkouts.dart';


class GetWorkouts {
  final GetRepository repository;

  GetWorkouts(this.repository);

  Future<List<Workout>> call() async {
    return await repository.getWorkouts();
  }
}
