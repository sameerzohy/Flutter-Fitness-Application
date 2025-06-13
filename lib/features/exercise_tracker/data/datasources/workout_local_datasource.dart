import 'package:fitness_app/core/error/failure.dart';
import 'package:fitness_app/features/exercise_tracker/data/models/workout_history_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:dartz/dartz.dart';

abstract class WorkoutLocalDataSource {
  Future<List<WorkoutHistoryModel>> loadWorkoutHistory(String exerciseId);
  Future<Unit> saveWorkoutHistory(String exerciseId, WorkoutHistoryModel workout);
  Future<List<WorkoutHistoryModel>> loadAllWorkoutHistory(); 
  Future<Unit> updateWorkoutHistory(String exerciseId, WorkoutHistoryModel workout); // Added update
  Future<Unit> deleteWorkoutHistory(String exerciseId, String workoutId); // Added delete individual
  Future<Unit> clearWorkoutHistory(String exerciseId);
  DateTime? getLastSyncDate(); // Added sync date methods
  Future<Unit> setLastSyncDate(DateTime date); // Added sync date methods
}

class WorkoutLocalDataSourceImpl implements WorkoutLocalDataSource {
  final Box<List> historyBox;
  final Box metaBox; // Added metaBox

  WorkoutLocalDataSourceImpl({required this.historyBox, required this.metaBox}); // Updated constructor

  @override
  Future<List<WorkoutHistoryModel>> loadWorkoutHistory(String exerciseId) async {
    try {
      final savedData = historyBox.get(exerciseId, defaultValue: [])?.cast<Map<dynamic, dynamic>>();
      if (savedData != null) {
        return savedData
            .map((item) => WorkoutHistoryModel.fromMap(Map<String, dynamic>.from(item)))
            .toList();
      }
      return [];
    } catch (e) {
      throw Failure(message: 'Failed to load workout history from local cache: $e');
    }
  }

@override
  Future<Unit> saveWorkoutHistory(String exerciseId, WorkoutHistoryModel workout) async {
    try {
      final currentHistory = (historyBox.get(exerciseId, defaultValue: []) ?? [])
          .cast<Map<dynamic, dynamic>>()
          .map((item) => Map<String, dynamic>.from(item))
          .toList();

      currentHistory.insert(0, workout.toMap()); // Add to the beginning
      await historyBox.put(exerciseId, currentHistory);
      return unit;
    } catch (e) {
      throw Failure(message: 'Failed to save workout history to local cache: $e');
    }
  }


  @override
  Future<Unit> updateWorkoutHistory(String exerciseId, WorkoutHistoryModel workout) async {
    try {
      final currentHistory = (historyBox.get(exerciseId, defaultValue: []) ?? [])
          .cast<Map<dynamic, dynamic>>()
          .map((item) => WorkoutHistoryModel.fromMap(Map<String, dynamic>.from(item)))
          .toList();

      final index = currentHistory.indexWhere((item) => item.id == workout.id);
      if (index != -1) {
        currentHistory[index] = workout; // Replace the old item with the updated one
        await historyBox.put(exerciseId, currentHistory.map((e) => e.toMap()).toList());
        return unit;
      } else {
        throw Failure(message: 'Workout history entry not found in local cache for update.');
      }
    } catch (e) {
      throw Failure(message: 'Failed to update workout history in local cache: $e');
    }
  }
 @override
  Future<List<WorkoutHistoryModel>> loadAllWorkoutHistory() async {
    try {
      final List<WorkoutHistoryModel> allHistory = [];
      for (var key in historyBox.keys) {
        final savedData = historyBox.get(key, defaultValue: [])?.cast<Map<dynamic, dynamic>>();
        if (savedData != null) {
          allHistory.addAll(savedData
              .map((item) => WorkoutHistoryModel.fromMap(Map<String, dynamic>.from(item))));
        }
      }
      return allHistory;
    } catch (e) {
      throw Failure(message: 'Failed to load all workout history from local cache: $e');
    }
  }
  @override
  Future<Unit> deleteWorkoutHistory(String exerciseId, String workoutId) async {
    try {
      final currentHistory = (historyBox.get(exerciseId, defaultValue: []) ?? [])
          .cast<Map<dynamic, dynamic>>()
          .map((item) => WorkoutHistoryModel.fromMap(Map<String, dynamic>.from(item)))
          .toList();

      currentHistory.removeWhere((item) => item.id == workoutId);
      await historyBox.put(exerciseId, currentHistory.map((e) => e.toMap()).toList());
      return unit;
    } catch (e) {
      throw Failure(message: 'Failed to delete workout history from local cache: $e');
    }
  }

  @override
  Future<Unit> clearWorkoutHistory(String exerciseId) async {
    try {
      await historyBox.put(exerciseId, []);
      return unit;
    } catch (e) {
      throw Failure(message: 'Failed to clear workout history from local cache: $e');
    }
  }

  @override
  DateTime? getLastSyncDate() {
    final millis = metaBox.get('last_supabase_sync') as int?;
    return millis != null ? DateTime.fromMillisecondsSinceEpoch(millis) : null;
  }

  @override
  Future<Unit> setLastSyncDate(DateTime date) async {
    try {
      await metaBox.put('last_supabase_sync', date.millisecondsSinceEpoch);
      return unit;
    } catch (e) {
      throw Failure(message: 'Failed to set last sync date in local cache: $e');
    }
  }
}