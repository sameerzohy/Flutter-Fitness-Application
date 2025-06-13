// lib/core/entities/scheduled_workout.dart
import 'package:equatable/equatable.dart';
import 'package:fitness_app/core/entities/exercise.dart'; // <<< Using your Exercise class

class ScheduledWorkout extends Equatable {
  final int? id; // Null for new workouts before they are saved
  final String title;
  final DateTime dateTime;
  final List<Exercise> exercises;
  final String userId; // <<< ADDED THIS

  const ScheduledWorkout({
    this.id,
    required this.title,
    required this.dateTime,
    required this.exercises,
    required this.userId, // <<< ADDED THIS
  });

  ScheduledWorkout copyWith({
    int? id,
    String? title,
    DateTime? dateTime,
    List<Exercise>? exercises,
    String? userId, // <<< ADDED THIS
  }) {
    return ScheduledWorkout(
      id: id ?? this.id,
      title: title ?? this.title,
      dateTime: dateTime ?? this.dateTime,
      exercises: exercises ?? this.exercises,
      userId: userId ?? this.userId, // <<< ADDED THIS
    );
  }

  @override
  List<Object?> get props => [id, title, dateTime, exercises, userId]; // <<< ADDED userId to props
}