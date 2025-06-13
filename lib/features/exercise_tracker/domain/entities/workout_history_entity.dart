import 'package:equatable/equatable.dart';

class WorkoutHistoryEntity extends Equatable {
  final String id;
  final String userId; // User who performed the workout
  final String exerciseId; // ID of the exercise (from ExerciseEntity)
  final DateTime timestamp; // When the workout was completed
  final int duration; // Duration in seconds
  final DateTime insertedAt; // When the record was inserted (for Supabase)

  const WorkoutHistoryEntity({
    required this.id,
    required this.userId,
    required this.exerciseId,
    required this.timestamp,
    required this.duration,
    required this.insertedAt,
  });

  @override
  List<Object?> get props => [id, userId, exerciseId, timestamp, duration, insertedAt];

  // Added copyWith for easier updates
  WorkoutHistoryEntity copyWith({
    String? id,
    String? userId,
    String? exerciseId,
    DateTime? timestamp,
    int? duration,
    DateTime? insertedAt,
  }) {
    return WorkoutHistoryEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      exerciseId: exerciseId ?? this.exerciseId,
      timestamp: timestamp ?? this.timestamp,
      duration: duration ?? this.duration,
      insertedAt: insertedAt ?? this.insertedAt,
    );
  }
}
