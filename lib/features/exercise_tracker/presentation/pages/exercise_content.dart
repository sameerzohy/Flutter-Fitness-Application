// lib/features/exercise_tracker/presentation/pages/exercise_content.dart
import 'package:fitness_app/core/theme/appPalatte.dart';

import 'package:fitness_app/features/exercise_tracker/domain/entities/scheduled_workout.dart';
import 'package:fitness_app/features/exercise_tracker/presentation/pages/ExerciseNavigator.dart';
import 'package:fitness_app/features/exercise_tracker/presentation/pages/ExerciseSchedulePage.dart';
import 'package:fitness_app/features/exercise_tracker/presentation/widgets/WorkoutCategoryCard.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fitness_app/init_dependency.dart';
import 'package:fitness_app/core/entities/exercise.dart';
import 'package:fitness_app/features/exercise_tracker/domain/usecases/schedule_usecases/fetch_exercises.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fitness_app/features/exercise_tracker/presentation/blocs/scheduled_workout/scheduled_workout_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

const List<Map<String, dynamic>> workoutCategories = [
  {
    "title": "Fullbody Workout",
    "subtitle": "11 Exercises | 32mins",
    "imgPath": "assets/images/fullbody1.png",
  },
  {
    "title": "Lowerbody Workout",
    "subtitle": "12 Exercises | 40mins",
    "imgPath": "assets/images/lowerbody.png",
  },
  {
    "title": "AB Workout",
    "subtitle": "14 Exercises | 20mins",
    "imgPath": "assets/images/ab.png",
  },
];

class ExerciseContent extends StatefulWidget {
  final ScrollController scrollController;

  const ExerciseContent({Key? key, required this.scrollController}) : super(key: key);

  @override
  State<ExerciseContent> createState() => _ExerciseContentState();
}

class _ExerciseContentState extends State<ExerciseContent> {
  List<ScheduledWorkout> _scheduledWorkouts = [];
  User? _currentUser;
  late final SupabaseClient _supabaseClient;

  @override
  void initState() {
    super.initState();
    _supabaseClient = Supabase.instance.client;
    
    _currentUser = _supabaseClient.auth.currentUser;
    print('ExerciseContent: initState - Initial currentUser: ${_currentUser?.id ?? "null"}');

    if (_currentUser != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<ScheduledWorkoutBloc>().add(FetchAllWorkoutsEvent(_currentUser!.id));
        print('ExerciseContent: initState - Dispatched FetchAllWorkoutsEvent for user: ${_currentUser!.id}');
      });
    } else {
      print('ExerciseContent: initState - User not logged in, no FetchAllWorkoutsEvent dispatched.');
    }

    _supabaseClient.auth.onAuthStateChange.listen((data) {
      if (mounted) {
        setState(() {
          _currentUser = data.session?.user;
          print('ExerciseContent: Auth State Changed - New currentUser: ${_currentUser?.id ?? "null"}');
          if (_currentUser != null) {
            context.read<ScheduledWorkoutBloc>().add(FetchAllWorkoutsEvent(_currentUser!.id));
            print('ExerciseContent: Auth State Changed - Re-dispatched FetchAllWorkoutsEvent for user: ${_currentUser!.id}');
          } else {
            _scheduledWorkouts = []; // Clear workouts if user logs out
            print('ExerciseContent: Auth State Changed - User logged out, cleared workouts.');
          }
        });
      }
    });
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(color: AppPallete.whiteColor)),
        backgroundColor: isError ? AppPallete.errorColor : AppPallete.gradient2,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(10),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      transform: Matrix4.translationValues(0, -30, 0),
      decoration: const BoxDecoration(
        color: AppPallete.whiteColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: ListView(
        controller: widget.scrollController,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        children: [
          Center(
            child: Container(
              width: 40,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // --- Daily Schedule Header ---
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Daily Workout Schedule",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppPallete.black),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppPallete.trackerContainerBackground2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                ),
                onPressed: () {
                  final fetchExercisesUseCase = sl<FetchExercises>();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ExerciseSchedulePage(
                        fetchExercises: fetchExercisesUseCase,
                      ),
                    ),
                  );
                },
                child: const Text("Check", style: TextStyle(color: AppPallete.whiteColor)),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // --- Newest Workout Section ---
          const Text(
            "Newest Workouts",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppPallete.black),
          ),
          const SizedBox(height: 12),

          BlocConsumer<ScheduledWorkoutBloc, ScheduledWorkoutState>(
            listener: (context, state) {
              if (state is ScheduledWorkoutsDisplaySuccess) {
                setState(() {
                  _scheduledWorkouts = state.scheduledWorkouts;
                  print('ExerciseContent Listener: Received ScheduledWorkoutsDisplaySuccess. Total workouts: ${_scheduledWorkouts.length}');
                  for (var i = 0; i < _scheduledWorkouts.length; i++) {
                    final workout = _scheduledWorkouts[i];
                    print('  Scheduled Workout [$i]: Title: ${workout.title}, DateTime: ${workout.dateTime}');
                  }
                });
              } else if (state is ScheduledWorkoutFailure) {
                _showSnackBar(state.message, isError: true);
                print('ExerciseContent Listener: ScheduledWorkoutFailure: ${state.message}');
              } else if (state is ScheduledWorkoutLoading) {
                   print('ExerciseContent Listener: ScheduledWorkoutLoading...');
              }
              if (state is ScheduledWorkoutSuccess || state is ScheduledWorkoutDeleteSuccess) {
                   print('ExerciseContent Listener: Workout CRUD success, re-fetching workouts.');
                   if (_currentUser != null) {
                     context.read<ScheduledWorkoutBloc>().add(FetchAllWorkoutsEvent(_currentUser!.id));
                   }
              }
            },
            builder: (context, state) {
              print('ExerciseContent Builder: Building UI. Current Bloc State: $state');
              print('ExerciseContent Builder: _currentUser is ${_currentUser?.id ?? "null"}');
              print('ExerciseContent Builder: _scheduledWorkouts length: ${_scheduledWorkouts.length}');

              if (state is ScheduledWorkoutLoading && _scheduledWorkouts.isEmpty) {
                print('ExerciseContent Builder: Showing loading indicator.');
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 20.0),
                    child: CircularProgressIndicator(color: AppPallete.gradient2),
                  ),
                );
              }

              if (_currentUser == null) {
                print('ExerciseContent Builder: User not logged in. Displaying login message.');
                return Text(
                  "Please log in to view workouts.",
                  style: TextStyle(fontSize: 14, color: AppPallete.greyColor.withOpacity(0.8)),
                );
              }

              // Sort all workouts by date/time in descending order to get the newest
              final sortedWorkouts = List<ScheduledWorkout>.from(_scheduledWorkouts)
                  ..sort((a, b) => b.dateTime.compareTo(a.dateTime));
              print('ExerciseContent Builder: Found ${sortedWorkouts.length} total workouts.');

              final workoutsToShow = sortedWorkouts.take(2).toList();
              print('ExerciseContent Builder: Displaying ${workoutsToShow.length} newest workouts.');

              if (workoutsToShow.isEmpty) {
                print('ExerciseContent Builder: No workouts to display.');
                return Text(
                  "No workouts found.",
                  style: TextStyle(fontSize: 14, color: AppPallete.greyColor.withOpacity(0.8)),
                );
              }

              // Display the newest workouts with new styling and onTap
              return Column(
                children: workoutsToShow.map((w) {
                  final formattedDate = DateFormat('MMM dd, hh:mm a').format(w.dateTime);
                  final exercisesCount = w.exercises.length;

                  return Card(
                    elevation: 6,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    margin: const EdgeInsets.only(bottom: 12),
                    child: InkWell(
                      onTap: () {
                        final fetchExercisesUseCase = sl<FetchExercises>();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ExerciseSchedulePage(
                              fetchExercises: fetchExercisesUseCase,
                            ),
                          ),
                        );
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            Icon(
                              Icons.event_note, // Current icon
                              color: AppPallete.gradient2,
                              size: 40,
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    w.title,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: AppPallete.black,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '$formattedDate | $exercisesCount Exercises',
                                    style: const TextStyle(fontSize: 14, color: AppPallete.greyColor),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(Icons.arrow_forward_ios, color: AppPallete.greyColor, size: 20),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              );
            },
          ),

          const SizedBox(height: 24),

          const Text(
            "What Do You Want to Train",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppPallete.black),
          ),
          const SizedBox(height: 16),

          ...workoutCategories.map(
            (category) => WorkoutCategoryCard(
              title: category['title'],
              subtitle: category['subtitle'],
              imgPath: category['imgPath'],
              onTap: () {
                ExerciseNavigator.goToWorkoutPage(
                  context,
                  workoutTitle: category['title'],
                  imagePath: category['imgPath'],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}