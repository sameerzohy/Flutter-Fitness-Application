import 'package:fitness_app/features/exercise_tracker/data/models/scheduled_workout.dart';
import 'package:flutter/foundation.dart';


// Global notifier to hold scheduled workouts list
ValueNotifier<List<ScheduledWorkout>> scheduledWorkoutsNotifier = ValueNotifier([]);
