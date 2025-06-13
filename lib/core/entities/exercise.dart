// lib/core/entities/exercise.dart
import 'package:uuid/uuid.dart'; // Make sure uuid package is in pubspec.yaml

class Exercise {
  final String id;
  final String name;
  final String? category;
  final String image;
  final String? reps; // Using 'reps' as per your provided class

  Exercise({
    String? id,
    required this.name,
    this.category,
    required this.image,
    this.reps,
  }) : id = id ?? const Uuid().v4();

  // Converts an Exercise object into a JSON map for storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'image': image,
      'reps': reps,
    };
  }

  // Factory constructor to create an Exercise object from a JSON map
  // This handles parsing from both workouts.json (which uses 'title', 'value')
  // and from Supabase (which will use 'name', 'reps').
  factory Exercise.fromJson(Map<String, dynamic> json) {
    final String parsedName = json['name'] as String? ?? json['title'] as String? ?? 'Unknown Exercise';
    final String? parsedReps = json['reps'] as String? ?? json['value'] as String?;

    return Exercise(
      id: json['id'] as String?, // Use existing ID if present
      name: parsedName,
      category: json['category'] as String?,
      image: json['image'] as String? ?? 'assets/images/placeholder.png',
      reps: parsedReps,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    // We compare by 'id' which is guaranteed to be unique
    return other is Exercise && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}