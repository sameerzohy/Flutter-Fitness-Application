import 'package:fitness_app/core/theme/appPalatte.dart';
import 'package:fitness_app/features/exercise_tracker/presentation/blocs/workout_history_bloc/workout_history_event.dart';
import 'package:fitness_app/features/exercise_tracker/presentation/pages/exercise_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fitness_app/features/exercise_tracker/presentation/blocs/workout_history_bloc/workout_history_bloc.dart';
import 'package:fitness_app/init_dependency.dart'; // for sl
import 'exercise_content.dart';

class ExercisePage extends StatelessWidget {
  const ExercisePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppPallete.gradient1,
      body: Stack(
        children: [
          // Provide the Bloc here and load event immediately
          BlocProvider(
            create:
                (_) => sl<WorkoutHistoryBloc>()..add(LoadAllWorkoutHistory()),
            child: const ExerciseHeader(),
          ),

          // Draggable content sliding over header
          DraggableScrollableSheet(
            initialChildSize: 0.4, // how much to show initially (40%)
            minChildSize: 0.4, // how much minimum it can shrink
            maxChildSize: 0.95, // how much it can expand
            builder: (context, scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8,
                      offset: Offset(0, -2),
                    ),
                  ],
                ),
                child: ExerciseContent(scrollController: scrollController),
              );
            },
          ),
        ],
      ),
    );
  }
}
