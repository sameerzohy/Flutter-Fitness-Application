import 'dart:async';
import 'package:fitness_app/core/cubits/cubit/app_user_cubit.dart';
import 'package:fitness_app/features/exercise_tracker/domain/entities/workout_history_entity.dart';
import 'package:fitness_app/features/exercise_tracker/presentation/blocs/workout_history_bloc/workout_history_bloc.dart';
import 'package:fitness_app/features/exercise_tracker/presentation/blocs/workout_history_bloc/workout_history_event.dart';
import 'package:fitness_app/features/exercise_tracker/presentation/blocs/workout_history_bloc/workout_history_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:fitness_app/core/theme/appPalatte.dart'; // Ensure this path is correct
import 'package:fitness_app/core/entities/exercise_entity.dart'; // Ensure this path is correct
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:uuid/uuid.dart'; // For generating UUIDs for workout history entries

class WorkoutTimer extends StatefulWidget {
  final VoidCallback onFinish;
  final ExerciseEntity exercise;

  const WorkoutTimer({
    Key? key,
    required this.onFinish,
    required this.exercise,
  }) : super(key: key);

  @override
  State<WorkoutTimer> createState() => _WorkoutTimerState();
}

class _WorkoutTimerState extends State<WorkoutTimer> {
  int _totalSeconds = 60;
  int _remainingSeconds = 60;
  Timer? _timer;
  bool _isRunning = false;

  @override
  void initState() {
    super.initState();
    // Load history when the widget initializes, filtered by exerciseId
    context.read<WorkoutHistoryBloc>().add(LoadWorkoutHistory(exerciseId: widget.exercise.name));
  }

  void _startTimer() {
    if (_isRunning) return;

    setState(() => _isRunning = true);

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds == 0) {
        _stopTimer(saveHistory: true);
        widget.onFinish();
      } else {
        setState(() {
          _remainingSeconds--;
        });
      }
    });
  }

  void _pauseTimer() {
    if (_timer != null && _isRunning) {
      _timer!.cancel();
      setState(() => _isRunning = false);
    }
  }

  void _stopTimer({bool saveHistory = false}) {
    _timer?.cancel();
    if (saveHistory) {
      final now = DateTime.now();
      // Accessing SupabaseClient via GetIt for userId for demonstration.
      // In a real app, you might pass the userId through the BLoC or use a dedicated auth service.
      final userId = Supabase.instance.client.auth.currentUser?.id ?? const Uuid().v4();
      print(userId);

      final workoutHistory = WorkoutHistoryEntity(
        id: const Uuid().v4(), // Generate a unique ID for this new workout entry
        userId: userId,
        exerciseId: widget.exercise.name,
        timestamp: now,
        duration: _totalSeconds,
        insertedAt: now,
      );
      context.read<WorkoutHistoryBloc>().add(SaveWorkoutHistoryEvent(workout: workoutHistory));
    }

    setState(() {
      _remainingSeconds = _totalSeconds;
      _isRunning = false;
    });
  }

  void _pickTime() async {
    final int? pickedMinutes = await showDialog<int>(
      context: context,
      builder: (context) {
        int tempSelected = _totalSeconds ~/ 60;
        return AlertDialog(
          title: const Text('Select Workout Duration (minutes)'),
          content: StatefulBuilder(
            builder: (context, setDialogState) => SizedBox(
              height: 150,
              child: Column(
                children: [
                  Slider(
                    min: 1,
                    max: 30,
                    divisions: 29,
                    label: '$tempSelected min',
                    value: tempSelected.toDouble(),
                    onChanged: (value) {
                      setDialogState(() {
                        tempSelected = value.toInt();
                      });
                    },
                  ),
                  Text('$tempSelected minutes'),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, null),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, tempSelected),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );

    if (pickedMinutes != null) {
      setState(() {
        _totalSeconds = pickedMinutes * 60;
        _remainingSeconds = _totalSeconds;
      });
    }
  }

  String _formatTime(int seconds) {
    final mins = seconds ~/ 60;
    final secs = seconds % 60;
    return '${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _confirmAndDeleteWorkout(WorkoutHistoryEntity workout) async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: const Text('Are you sure you want to delete this workout entry?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      context.read<WorkoutHistoryBloc>().add(
            DeleteWorkoutHistoryEvent(
              exerciseId: workout.exerciseId,
              workoutId: workout.id,
            ),
          );
    }
  }

  Future<void> _confirmAndClearAllWorkouts(String exerciseId) async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirm Clear All'),
          content: const Text('Are you sure you want to delete ALL workout entries for this exercise? This action cannot be undone.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Clear All'),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      context.read<WorkoutHistoryBloc>().add(
            ClearAllWorkoutHistory(exerciseId: exerciseId),
          );
    }
  }


  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final progress = _remainingSeconds / _totalSeconds;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: _pickTime,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: 150,
                  width: 150,
                  child: CircularProgressIndicator(
                    value: progress,
                    strokeWidth: 10,
                    backgroundColor: AppPallete.greyColor.withOpacity(0.3),
                    valueColor:
                        AlwaysStoppedAnimation<Color>(AppPallete.gradient2),
                  ),
                ),
                Text(
                  _formatTime(_remainingSeconds),
                  style: const TextStyle(
                      fontSize: 36, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: _isRunning ? null : _startTimer,
                icon: const Icon(Icons.play_arrow),
                label: const Text('Start'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppPallete.gray1,
                  minimumSize: const Size(100, 40),
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton.icon(
                onPressed: _isRunning ? _pauseTimer : null,
                icon: const Icon(Icons.pause),
                label: const Text('Pause'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppPallete.gradient1,
                  minimumSize: const Size(100, 40),
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton.icon(
                onPressed: _isRunning || _remainingSeconds != _totalSeconds
                    ? () => _stopTimer(saveHistory: true)
                    : null,
                icon: const Icon(Icons.stop),
                label: const Text('Stop'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  minimumSize: const Size(100, 40),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // History
          BlocConsumer<WorkoutHistoryBloc, WorkoutHistoryState>(
            listener: (context, state) {
              if (state is WorkoutHistoryActionSuccess) {
                _showSnackBar(state.message);
              } else if (state is WorkoutHistoryError) {
                _showSnackBar(state.message, isError: true);
              }
            },
            builder: (context, state) {
              if (state is WorkoutHistoryLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is WorkoutHistoryLoaded) {
                // Filter history to only show entries matching the current exerciseId
                final filteredHistory = state.history
                    .where((item) => item.exerciseId == widget.exercise.name)
                    .toList();

                if (filteredHistory.isEmpty) {
                  return const Text('No previous workouts for this exercise.');
                }
                return Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Previous Workouts',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        TextButton.icon(
                          onPressed: () => _confirmAndClearAllWorkouts(widget.exercise.name),
                          icon: const Icon(Icons.delete_forever, color: Colors.red),
                          label: const Text('Clear All',
                              style: TextStyle(color: Colors.red)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ListView.builder(
                      itemCount: filteredHistory.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        final item = filteredHistory[index];
                        final formattedDate =
                            DateFormat('EEEE, MMM d • hh:mm a').format(item.timestamp);
                        final durationMins = item.duration ~/ 60;
                        return Container(
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          decoration: BoxDecoration(
                            color: AppPallete.gray2.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              )
                            ],
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            leading: const Icon(Icons.fitness_center,
                                color: Colors.deepPurple),
                            title: Text(
                              '${item.exerciseId} – $durationMins minutes',
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                            subtitle: Text(
                              formattedDate,
                              style: const TextStyle(color: Colors.grey),
                            ),
                            trailing: IconButton( // Only delete icon remains
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _confirmAndDeleteWorkout(item),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                );
              } else if (state is WorkoutHistoryError) {
                return Center(child: Text('Error: ${state.message}'));
              }
              return const SizedBox.shrink(); // Initial state or other states
            },
          ),
        ],
      ),
    );
  }
}