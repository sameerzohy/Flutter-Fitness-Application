import 'package:fitness_app/core/error/failure.dart';
import 'package:fitness_app/features/exercise_tracker/data/models/workout_history_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:dartz/dartz.dart';
import 'package:uuid/uuid.dart'; // For generating UUIDs

abstract class WorkoutRemoteDataSource {
  Future<List<WorkoutHistoryModel>> loadWorkoutHistory(String exerciseId);
  Future<Unit> saveWorkoutHistory(WorkoutHistoryModel workout);
  Future<List<WorkoutHistoryModel>> loadAllWorkoutHistory();
  Future<Unit> updateWorkoutHistory(
    WorkoutHistoryModel workout,
  ); // Added update
  Future<Unit> deleteWorkoutHistory(
    String workoutId,
  ); // Added delete individual
  Future<Unit> clearWorkoutHistory(String exerciseId);
}

class WorkoutRemoteDataSourceImpl implements WorkoutRemoteDataSource {
  final SupabaseClient supabaseClient;
  final Uuid uuid; // For generating UUIDs for user_id if not authenticated

  WorkoutRemoteDataSourceImpl({
    required this.supabaseClient,
    required this.uuid,
  });

  @override
  Future<List<WorkoutHistoryModel>> loadWorkoutHistory(
    String exerciseId,
  ) async {
    try {
      final response = await supabaseClient
          .from('workout_history')
          .select()
          .eq('exercise_id', exerciseId)
          .order('timestamp', ascending: false)
          .limit(100); // Limit to a reasonable number of past workouts

      return (response as List)
          .map(
            (json) => WorkoutHistoryModel.fromMap(json as Map<String, dynamic>),
          )
          .toList();
    } on PostgrestException catch (e) {
      throw Failure(
        message: 'Supabase error loading workout history: ${e.message}',
      );
    } catch (e) {
      throw Failure(
        message: 'Failed to load workout history from Supabase: $e',
      );
    }
  }

  @override
  Future<List<WorkoutHistoryModel>> loadAllWorkoutHistory() async {
    try {
      final response = await supabaseClient
          .from('workout_history')
          .select()
          .order('timestamp', ascending: false); // Fetch all history

      return (response as List)
          .map(
            (json) =>
                WorkoutHistoryModel.fromMap(Map<String, dynamic>.from(json)),
          )
          .toList();
    } on PostgrestException catch (e) {
      throw Failure(
        message: 'Supabase error loading all workout history: ${e.message}',
      );
    } catch (e) {
      throw Failure(
        message: 'Failed to load all workout history from Supabase: $e',
      );
    }
  }

  @override
  Future<Unit> saveWorkoutHistory(WorkoutHistoryModel workout) async {
    try {
      // Get current authenticated user ID or generate a dummy one
      final userId = supabaseClient.auth.currentUser?.id ?? uuid.v4();

      // Ensure the model has the user_id and a unique ID if not already set
      final workoutToSave = workout.copyWith(
        userId: userId,
        id: workout.id, // Generate ID if not present
      );

      await supabaseClient
          .from('workout_history')
          .insert(workoutToSave.toMap());
      return unit;
    } on PostgrestException catch (e) {
      throw Failure(
        message: 'Supabase error saving workout history: ${e.message}',
      );
    } catch (e) {
      throw Failure(message: 'Failed to save workout history to Supabase: $e');
    }
  }

  @override
  Future<Unit> updateWorkoutHistory(WorkoutHistoryModel workout) async {
    try {
      await supabaseClient
          .from('workout_history')
          .update(workout.toMap())
          .eq('id', workout.id); // Update by ID
      return unit;
    } on PostgrestException catch (e) {
      throw Failure(
        message: 'Supabase error updating workout history: ${e.message}',
      );
    } catch (e) {
      throw Failure(
        message: 'Failed to update workout history in Supabase: $e',
      );
    }
  }

  @override
  Future<Unit> deleteWorkoutHistory(String workoutId) async {
    // Added delete individual
    try {
      await supabaseClient
          .from('workout_history')
          .delete()
          .eq('id', workoutId); // Delete by ID
      return unit;
    } on PostgrestException catch (e) {
      throw Failure(
        message: 'Supabase error deleting workout history: ${e.message}',
      );
    } catch (e) {
      throw Failure(
        message: 'Failed to delete workout history from Supabase: $e',
      );
    }
  }

  @override
  Future<Unit> clearWorkoutHistory(String exerciseId) async {
    try {
      // For clearing, you might want to only allow clearing for the current user
      // or for a specific exercise for all users, depending on your app logic.
      // Here, we'll clear all entries for the given exercise_id.
      // If you want to clear only for the current user, add .eq('user_id', supabaseClient.auth.currentUser?.id)
      await supabaseClient
          .from('workout_history')
          .delete()
          .eq('exercise_id', exerciseId);
      return unit;
    } on PostgrestException catch (e) {
      throw Failure(
        message: 'Supabase error clearing workout history: ${e.message}',
      );
    } catch (e) {
      throw Failure(
        message: 'Failed to clear workout history from Supabase: $e',
      );
    }
  }
}
