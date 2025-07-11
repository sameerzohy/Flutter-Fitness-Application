import 'package:fitness_app/features/exercise_tracker/domain/entities/workout_history_entity.dart';
import 'package:fitness_app/features/exercise_tracker/presentation/blocs/workout_history_bloc/workout_history_bloc.dart';
import 'package:fitness_app/features/exercise_tracker/presentation/blocs/workout_history_bloc/workout_history_event.dart';
import 'package:fitness_app/features/exercise_tracker/presentation/blocs/workout_history_bloc/workout_history_state.dart';
import 'package:fitness_app/features/exercise_tracker/presentation/widgets/exercise_time_graph.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:fitness_app/core/theme/appPalatte.dart';

class ExerciseHeader extends StatefulWidget {
  const ExerciseHeader({super.key});

  @override
  State<ExerciseHeader> createState() => _ExerciseHeaderState();
}

class _ExerciseHeaderState extends State<ExerciseHeader> {
  @override
  void initState() {
    super.initState();
    print("ExerciseHeader: initState - adding LoadAllWorkoutHistory event");
    context.read<WorkoutHistoryBloc>().add(LoadAllWorkoutHistory());
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: AppPallete.gradient1,
        statusBarIconBrightness: Brightness.dark,
      ),
    );

    return Scaffold(
      body: Stack(
        children: [
          // Background gradient
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppPallete.trackerContainerBackground1,
                    AppPallete.trackerContainerBackground2,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Back button and title
                  Row(
                    children: [
                      const Expanded(
                        child: Center(
                          child: Text(
                            'Track Your Workout',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 35), // spacer to balance back icon
                    ],
                  ),

                  const SizedBox(height: 30),

                  BlocBuilder<WorkoutHistoryBloc, WorkoutHistoryState>(
                    builder: (context, state) {
                      print("WorkoutHistoryBloc State: $state");
                      if (state is WorkoutHistoryLoading) {
                        return const Center(
                          child: CircularProgressIndicator(color: Colors.white),
                        );
                      } else if (state is WorkoutHistoryLoaded) {
                        final chartData = _processWorkoutHistory(state.history);

                        if (chartData.exerciseMinutes.every((m) => m == 0)) {
                          return const Center(
                            child: Text(
                              'No workout data available for the last 7 days.',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          );
                        }

                        return ExerciseTimeBarChart(
                          data: chartData.exerciseMinutes,
                          labels: chartData.weekLabels,

                          touchedBarColor: AppPallete.gradient2,
                          barBackgroundColor: Colors.white.withOpacity(0.3),
                        );
                      } else if (state is WorkoutHistoryError) {
                        return Center(
                          child: Text(
                            'Error: ${state.message}',
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 16,
                            ),
                          ),
                        );
                      }
                      return const Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  WorkoutChartData _processWorkoutHistory(List<WorkoutHistoryEntity> history) {
    DateTime today = DateTime.now();
    final startDate = DateTime(
      today.year,
      today.month,
      today.day,
    ).subtract(const Duration(days: 6));
    Map<DateTime, double> dailyDurations = {};

    for (int i = 0; i < 7; i++) {
      final day = startDate.add(Duration(days: i));
      dailyDurations[day] = 0.0;
    }

    for (var workout in history) {
      final workoutDay = DateTime(
        workout.timestamp.year,
        workout.timestamp.month,
        workout.timestamp.day,
      );
      if (!workoutDay.isBefore(startDate) &&
          !workoutDay.isAfter(today.add(const Duration(days: 1)))) {
        dailyDurations.update(
          workoutDay,
          (value) => value + (workout.duration / 60.0),
          ifAbsent: () => (workout.duration / 60.0),
        );
      }
    }

    final List<double> minutesData = [];
    final List<String> labelsData = [];

    for (int i = 0; i < 7; i++) {
      final day = startDate.add(Duration(days: i));
      minutesData.add(dailyDurations[day] ?? 0.0);
      labelsData.add(DateFormat('EEE').format(day));
    }

    print("Workout minutes for last 7 days: $minutesData");
    print("Chart labels for last 7 days: $labelsData");

    return WorkoutChartData(
      exerciseMinutes: minutesData,
      weekLabels: labelsData,
    );
  }
}

class WorkoutChartData {
  final List<double> exerciseMinutes;
  final List<String> weekLabels;

  WorkoutChartData({required this.exerciseMinutes, required this.weekLabels});
}
