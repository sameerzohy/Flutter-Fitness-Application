// lib/domain/entities/workout_entity.dart
class WorkoutEntity {
  final String exerciseId;
  final DateTime timestamp;
  final int duration;

  WorkoutEntity({
    required this.exerciseId,
    required this.timestamp,
    required this.duration,
  });

  Map<String, dynamic> toJson(String userId) {
    return {
      'user_id': userId,
      'exercise_id': exerciseId,
      'timestamp': timestamp.toIso8601String(),
      'duration': duration,
    };
  }
}
