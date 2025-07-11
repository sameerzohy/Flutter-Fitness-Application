import 'package:fitness_app/features/exercise_tracker/domain/entities/workout_history_entity.dart';

class WorkoutHistoryModel extends WorkoutHistoryEntity {
  const WorkoutHistoryModel({
    required super.id,
    required super.userId,
    required super.exerciseId,
    required super.timestamp,
    required super.duration,
    required super.insertedAt,
  });

  factory WorkoutHistoryModel.fromMap(Map<String, dynamic> map) {
    return WorkoutHistoryModel(
      id: map['id'] as String,
      userId: map['user_id'] as String,
      exerciseId: map['exercise_id'] as String,
      timestamp: DateTime.parse(map['timestamp'] as String),
      duration: map['duration'] as int,
      insertedAt: DateTime.parse(map['inserted_at'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'exercise_id': exerciseId,
      'timestamp': timestamp.toIso8601String(), // Supabase expects ISO 8601
      'duration': duration,
      'inserted_at': insertedAt.toIso8601String(),
    };
  }

  @override // Override to ensure the copyWith from entity is also available
  WorkoutHistoryModel copyWith({
    String? id,
    String? userId,
    String? exerciseId,
    DateTime? timestamp,
    int? duration,
    DateTime? insertedAt,
  }) {
    return WorkoutHistoryModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      exerciseId: exerciseId ?? this.exerciseId,
      timestamp: timestamp ?? this.timestamp,
      duration: duration ?? this.duration,
      insertedAt: insertedAt ?? this.insertedAt,
    );
  }
}
