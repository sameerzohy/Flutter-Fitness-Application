import 'package:fitness_app/core/theme/appPalatte.dart';

import 'package:fitness_app/features/exercise_tracker/presentation/blocs/workout_history_bloc/workout_history_bloc.dart';

import 'package:fitness_app/init_dependency.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fitness_app/core/entities/exercise_entity.dart';
import 'package:fitness_app/features/exercise_tracker/presentation/widgets/workout_timer.dart';
// Your GetIt locator file

import 'package:fitness_app/features/exercise_tracker/presentation/blocs/workout_history_bloc/workout_history_event.dart' as bloc_event;

class WorkoutDetailPage extends StatelessWidget {
  final ExerciseEntity exercise;

  const WorkoutDetailPage({Key? key, required this.exercise}) : super(key: key);

  void _onWorkoutComplete(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Workout Completed!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppPallete.backgroundColor,
      appBar: AppBar(
        title: Text(exercise.name),
        centerTitle: true,
        backgroundColor: AppPallete.trackerContainerBackground1,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),

            Center(
              child: Container(
                height: 200,
                width: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Image.asset(exercise.image, fit: BoxFit.contain),
                ),
              ),
            ),

            const SizedBox(height: 24),

            Center(
              child: Text(
                exercise.name,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 8),

            Center(
              child: Text(
                'Reps: ${exercise.value}',
                style: const TextStyle(fontSize: 18, color: Colors.grey),
              ),
            ),

            const SizedBox(height: 24),

            // BlocProvider for WorkoutHistoryBloc with event dispatch
           BlocProvider(
  create: (context) => sl<WorkoutHistoryBloc>()
    ..add(bloc_event.LoadWorkoutHistory(exerciseId: exercise.name)),
  child: WorkoutTimer(
    exercise: exercise,
    onFinish: () => _onWorkoutComplete(context),
  ),
),


            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
