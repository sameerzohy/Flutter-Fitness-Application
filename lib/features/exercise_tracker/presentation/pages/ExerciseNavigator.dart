import 'package:fitness_app/features/exercise_tracker/presentation/pages/FullbodyWorkoutPage.dart';
import 'package:fitness_app/features/exercise_tracker/presentation/pages/LowerbodyWorkoutPage.dart';
import 'package:fitness_app/features/exercise_tracker/presentation/pages/ab_workout_page..dart';  // fixed double-dot typo
import 'package:flutter/material.dart';

class ExerciseNavigator {
  static void goToWorkoutPage(
    BuildContext context, {
    required String workoutTitle,
    required String imagePath,
  }) {
    Widget page;

    switch (workoutTitle.toLowerCase()) {
      case 'fullbody workout':
        page = FullbodyWorkoutPage(
          title: workoutTitle,
          imagePath: imagePath,
          category: 'full_body',  // pass correct category here
        );
        break;

      case 'lowerbody workout':
        page = LowerbodyWorkoutPage(
          title: workoutTitle,
          imagePath: imagePath,
          category: 'lower_body',  // pass correct category here
        );
        break;

      case 'ab workout':
        page = AbWorkoutPage(
          title: workoutTitle,
          imagePath: imagePath,
          category: 'abs',  // pass correct category here
        );
        break;

      default:
        page = Scaffold(
          appBar: AppBar(title: const Text('Unknown Workout')),
          body: const Center(child: Text('No page available for this workout')),
        );
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => page),
    );
  }
}
