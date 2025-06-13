import 'package:fitness_app/core/entities/exercise.dart';

class Workout {
  final String id;
  final String title;
  final String time;
  final bool isActive;
  final List<Exercise> exercises;

  Workout({
    required this.id,
    required this.title,
    required this.time,
    required this.isActive,
    required this.exercises,
  });
}
