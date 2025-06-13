// lib/features/exercise_tracker/data/datasources/scheduled_workout_remote_datasource.dart
import 'package:fitness_app/core/error/exception.dart';

import 'package:fitness_app/features/exercise_tracker/data/models/scheduled_workout_model2.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class ScheduledWorkoutRemoteDataSource {
  Future<ScheduledWorkoutModel> createScheduledWorkout(ScheduledWorkoutModel workout);
  Future<ScheduledWorkoutModel> updateScheduledWorkout(ScheduledWorkoutModel workout);
  Future<void> deleteScheduledWorkout(int id, String userId);
  Future<List<ScheduledWorkoutModel>> fetchAllScheduledWorkouts(String userId);
}

class ScheduledWorkoutRemoteDataSourceImpl implements ScheduledWorkoutRemoteDataSource {
  final SupabaseClient supabaseClient;

  ScheduledWorkoutRemoteDataSourceImpl(this.supabaseClient);

  @override
  Future<ScheduledWorkoutModel> createScheduledWorkout(ScheduledWorkoutModel workout) async {
    try {
      final response = await supabaseClient
          .from('scheduled_workouts')
          .insert(workout.toJson())
          .select()
          .single();

      return ScheduledWorkoutModel.fromJson(response);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<ScheduledWorkoutModel> updateScheduledWorkout(ScheduledWorkoutModel workout) async {
    try {
      final response = await supabaseClient
          .from('scheduled_workouts')
          .update(workout.toJson())
          .eq('id', workout.id!)
          .eq('user_id', workout.userId)
          .select()
          .single();

      return ScheduledWorkoutModel.fromJson(response);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<void> deleteScheduledWorkout(int id, String userId) async {
    try {
      await supabaseClient
          .from('scheduled_workouts')
          .delete()
          .eq('id', id)
          .eq('user_id', userId);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<List<ScheduledWorkoutModel>> fetchAllScheduledWorkouts(String userId) async {
    try {
      final response = await supabaseClient
          .from('scheduled_workouts')
          .select('*')
          .eq('user_id', userId)
          .order('date_time', ascending: true);

      return response
          .map((workoutData) => ScheduledWorkoutModel.fromJson(workoutData))
          .toList();
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}