import 'package:fitness_app/core/entities/workout.dart' as workout_entity;
import 'package:fitness_app/core/entities/exercise.dart' as exercise_entity;

class WorkoutModel extends workout_entity.Workout {
  WorkoutModel({
    required super.id,
    required super.title,
    required super.time,
    required super.isActive,
    required super.exercises,
  });

  factory WorkoutModel.fromJson(Map<String, dynamic> json) {
    return WorkoutModel(
      id: json['id'],
      title: json['title'],
      time: json['time'],
      isActive: json['isActive'],
      exercises:
          (json['exercises'] as List<dynamic>)
              .map((e) => exercise_entity.Exercise.fromJson(e))
              .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'time': time,
      'isActive': isActive,
      'exercises': exercises.map((e) => e.toJson()).toList(),
    };
  }
}
