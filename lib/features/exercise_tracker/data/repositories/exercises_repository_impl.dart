// lib/features/exercise_tracker/data/repositories/exercises_repository_impl.dart
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:fitness_app/core/entities/exercise.dart';
import 'package:fitness_app/features/exercise_tracker/domain/repositories/exercises_repository.dart';

class ExercisesRepositoryImpl implements ExercisesRepository {
  @override
  Future<Map<String, List<Exercise>>> loadExercises() async {
    try {
      print('Loading JSON string from assets/data/workouts.json...');
      final String jsonString = await rootBundle.loadString('assets/data/workouts.json');
      print('JSON string loaded.');
      final Map<String, dynamic> decodedJson = jsonDecode(jsonString);
      print('JSON decoded into Map with keys: ${decodedJson.keys}');

      final Map<String, List<Exercise>> exercisesByCategory = {};

      decodedJson.forEach((category, exercisesList) {
        if (exercisesList is List) {
          final List<Exercise> parsedExercises = exercisesList.map((jsonExercise) {
            final Map<String, dynamic> exerciseMap = Map<String, dynamic>.from(jsonExercise as Map<String, dynamic>);
            exerciseMap['category'] = category; // Inject the category
            return Exercise.fromJson(exerciseMap); // Parse using Exercise.fromJson
          }).toList();
          exercisesByCategory[category] = parsedExercises;
          print("Parsed category: $category with ${parsedExercises.length} exercises.");
        } else {
          print("Warning: '$category' in JSON is not a List. Skipping.");
        }
      });
      return exercisesByCategory;
    } catch (e) {
      print("Error in ExercisesRepositoryImpl.loadExercises: $e");
      rethrow;
    }
  }
}