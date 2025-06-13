// lib/features/exercise_tracker/domain/entities/scheduled_workout.dart
import 'package:fitness_app/core/entities/exercise.dart';
import 'package:flutter/foundation.dart'; // Import for listEquals

class ScheduledWorkout {
  final int? id;
  final String title;
  final DateTime dateTime;
  final List<Exercise> exercises; // This list holds full Exercise objects for UI display
  final String userId; // Added userId as per your Supabase schema

  ScheduledWorkout({
    this.id,
    required this.title,
    required this.dateTime,
    required this.exercises,
    required this.userId, // Must be required as it's NOT NULL in DB
  });

  ScheduledWorkout copyWith({
    int? id,
    String? title,
    DateTime? dateTime,
    List<Exercise>? exercises,
    String? userId,
  }) {
    return ScheduledWorkout(
      id: id ?? this.id,
      title: title ?? this.title,
      dateTime: dateTime ?? this.dateTime,
      exercises: exercises ?? this.exercises,
      userId: userId ?? this.userId,
    );
  }

  // Factory constructor to create a ScheduledWorkout from a JSON map (e.g., from Supabase response)
  factory ScheduledWorkout.fromJson(Map<String, dynamic> json) {
    return ScheduledWorkout(
      id: json['id'] as int, // ID will always be present when reading from DB
      title: json['title'] as String,
      dateTime: DateTime.parse(json['date_time'] as String), // Parse from DB's 'date_time'
      exercises: (json['exercises'] as List)
          .map((e) => Exercise.fromJson(e as Map<String, dynamic>))
          .toList(),
      userId: json['user_id'] as String, // Read userId from DB
    );
  }

  // Converts a ScheduledWorkout object to a JSON map for Supabase
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> jsonMap = {
      'title': title,
      'date_time': dateTime.toIso8601String(), // Format DateTime for Supabase timestamptz
      'exercises': exercises.map((e) => e.toJson()).toList(), // Convert list of Exercise objects
      'user_id': userId, // Include userId
    };

    // IMPORTANT: Only include 'id' if it's not null.
    // This allows the database to auto-generate the ID for new records.
    if (id != null) {
      jsonMap['id'] = id;
    }
    return jsonMap;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true; // Same object instance
    // Check if runtime type is the same and all relevant properties are equal
    return other is ScheduledWorkout &&
        runtimeType == other.runtimeType && // Ensure same type
        id == other.id &&
        title == other.title &&
        dateTime == other.dateTime &&
        userId == other.userId &&
        // Use listEquals from 'package:flutter/foundation.dart' to compare lists
        listEquals(exercises, other.exercises);
  }

  @override
  int get hashCode => Object.hash(
        id,
        title,
        dateTime,
        userId,
        // When hashing lists, you can hash the list itself, or use a deep hash if necessary
        // For listEquals to work, the elements themselves (Exercise objects) must have
        // correct operator== and hashCode defined, which you already did for Exercise.
        Object.hashAll(exercises), // Hash all elements of the list
      );
}