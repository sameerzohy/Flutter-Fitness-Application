// lib/features/exercise_tracker/presentation/pages/exercise_schedule_page.dart
import 'package:fitness_app/core/theme/appPalatte.dart';
import 'package:fitness_app/core/usecases/usecase.dart';
import 'package:fitness_app/features/exercise_tracker/domain/entities/scheduled_workout.dart';
import 'package:fitness_app/features/exercise_tracker/domain/usecases/schedule_usecases/fetch_exercises.dart';
import 'package:fitness_app/features/exercise_tracker/presentation/blocs/scheduled_workout/scheduled_workout_bloc.dart';

import 'package:fitness_app/features/exercise_tracker/presentation/widgets/scheduled_workout_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:fitness_app/core/entities/exercise.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

class ExerciseSchedulePage extends StatefulWidget {
  final FetchExercises fetchExercises;

  const ExerciseSchedulePage({super.key, required this.fetchExercises});

  @override
  State<ExerciseSchedulePage> createState() => _ExerciseSchedulePageState();
}

class _ExerciseSchedulePageState extends State<ExerciseSchedulePage> {
  DateTime selectedDate = DateTime.now();
  final TextEditingController workoutTitleController = TextEditingController();

  Map<String, List<Exercise>> exercisesByCategory = {};
  List<Exercise> selectedExercises = [];
  bool isLoadingExercises = true;

  User? _currentUser;
  late final SupabaseClient _supabaseClient;

  @override
  void initState() {
    super.initState();
    _supabaseClient = Supabase.instance.client;
    _initializeUserAndWorkouts();

    _supabaseClient.auth.onAuthStateChange.listen((data) {
      if (mounted) {
        setState(() {
          _currentUser = data.session?.user;
          if (_currentUser != null) {
            context.read<ScheduledWorkoutBloc>().add(
              FetchAllWorkoutsEvent(_currentUser!.id),
            );
          } else {
            //context.read<ScheduledWorkoutBloc>().add(const ScheduledWorkoutsDisplaySuccess([]));
          }
        });
      }
    });
  }

  Future<void> _initializeUserAndWorkouts() async {
    _currentUser = _supabaseClient.auth.currentUser;

    if (_currentUser == null) {
      setState(() {
        isLoadingExercises = false;
      });
      _showSnackBar(
        'Please log in to schedule and view workouts.',
        isError: true,
      );
      return;
    }

    _loadExercises();
    context.read<ScheduledWorkoutBloc>().add(
      FetchAllWorkoutsEvent(_currentUser!.id),
    );
  }

  @override
  void dispose() {
    workoutTitleController.dispose();
    super.dispose();
  }

  Future<void> _loadExercises() async {
    if (!isLoadingExercises) {
      setState(() {
        isLoadingExercises = true;
      });
    }

    final res = await widget.fetchExercises(NoParams());
    res.fold(
      (failure) {
        print("Error loading exercises: ${failure.message}");
        _showSnackBar(
          "Failed to load available exercises: ${failure.message}",
          isError: true,
        );
        setState(() {
          isLoadingExercises = false;
        });
      },
      (loadedData) {
        setState(() {
          exercisesByCategory = loadedData;
          isLoadingExercises = false;
        });
      },
    );
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? AppPallete.errorColor : AppPallete.gradient2,
      ),
    );
  }

  void _handleCreateOrUpdate(int? workoutId) {
    if (_currentUser == null) {
      _showSnackBar(
        'You must be logged in to perform this action.',
        isError: true,
      );
      return;
    }

    final title = workoutTitleController.text.trim();
    if (title.isEmpty) {
      _showSnackBar("Please enter workout title", isError: true);
      return;
    }
    if (selectedExercises.isEmpty) {
      _showSnackBar("Please select at least one exercise", isError: true);
      return;
    }

    if (workoutId == null) {
      context.read<ScheduledWorkoutBloc>().add(
        CreateWorkoutEvent(
          title: title,
          dateTime: selectedDate,
          exercises: List.from(selectedExercises),
          userId: _currentUser!.id,
        ),
      );
    } else {
      context.read<ScheduledWorkoutBloc>().add(
        UpdateWorkoutEvent(
          id: workoutId,
          title: title,
          dateTime: selectedDate,
          exercises: List.from(selectedExercises),
          userId: _currentUser!.id,
        ),
      );
    }
  }

  Future<void> _showScheduleDialog({ScheduledWorkout? workoutToEdit}) async {
    if (_currentUser == null) {
      _showSnackBar('Please log in to schedule workouts.', isError: true);
      return;
    }

    if (workoutToEdit != null) {
      workoutTitleController.text = workoutToEdit.title;
      selectedExercises = List.from(workoutToEdit.exercises);
      selectedDate = workoutToEdit.dateTime;
    } else {
      workoutTitleController.clear();
      selectedExercises.clear();
      selectedDate = DateTime.now();
    }

    DateTime tempSelectedDate = selectedDate;
    List<Exercise> tempSelectedExercises = List.from(selectedExercises);

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: AppPallete.greycard1,
              title: Text(
                workoutToEdit == null ? "Schedule New Workout" : "Edit Workout",
                style: const TextStyle(color: AppPallete.black),
              ),
              content: SizedBox(
                width: double.maxFinite,
                height: MediaQuery.of(context).size.height * 0.7,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextField(
                      controller: workoutTitleController,
                      decoration: InputDecoration(
                        hintText: "Workout title",
                        border: const OutlineInputBorder(),
                        hintStyle: TextStyle(
                          color: const Color.fromARGB(
                            255,
                            18,
                            18,
                            18,
                          ).withOpacity(0.7),
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color.fromARGB(255, 0, 0, 0),
                          ),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: AppPallete.gradient2),
                        ),
                      ),
                      style: const TextStyle(
                        color: Color.fromARGB(255, 0, 0, 0),
                      ),
                      cursorColor: AppPallete.gradient2,
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      icon: const Icon(
                        Icons.calendar_today,
                        color: Color.fromARGB(255, 3, 3, 3),
                      ),
                      label: Text(
                        "Pick Date: ${DateFormat('MMM d, hh:mm a').format(tempSelectedDate)}",
                        style: const TextStyle(
                          color: Color.fromARGB(255, 0, 0, 0),
                        ),
                      ),
                      onPressed: () async {
                        final pickedDate = await showDatePicker(
                          context: context,
                          initialDate: tempSelectedDate,
                          firstDate: DateTime.now().subtract(
                            const Duration(days: 365),
                          ),
                          lastDate: DateTime.now().add(
                            const Duration(days: 365 * 5),
                          ),
                          builder: (context, child) {
                            return Theme(
                              data: ThemeData.dark().copyWith(
                                colorScheme: const ColorScheme.dark(
                                  primary: AppPallete.gradient2,
                                  onPrimary: AppPallete.whiteColor,
                                  surface: AppPallete.gray2,
                                  onSurface: AppPallete.whiteColor,
                                ),
                                textButtonTheme: TextButtonThemeData(
                                  style: TextButton.styleFrom(
                                    foregroundColor: AppPallete.gradient2,
                                  ),
                                ),
                              ),
                              child: child!,
                            );
                          },
                        );
                        if (pickedDate != null) {
                          final pickedTime = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.fromDateTime(
                              tempSelectedDate,
                            ),
                            builder: (context, child) {
                              return Theme(
                                data: ThemeData.dark().copyWith(
                                  colorScheme: const ColorScheme.dark(
                                    primary: AppPallete.gradient2,
                                    onPrimary: AppPallete.whiteColor,
                                    surface: AppPallete.gray2,
                                    onSurface: AppPallete.whiteColor,
                                  ),
                                  textButtonTheme: TextButtonThemeData(
                                    style: TextButton.styleFrom(
                                      foregroundColor: AppPallete.gradient2,
                                    ),
                                  ),
                                ),
                                child: child!,
                              );
                            },
                          );
                          if (pickedTime != null) {
                            setDialogState(() {
                              tempSelectedDate = DateTime(
                                pickedDate.year,
                                pickedDate.month,
                                pickedDate.day,
                                pickedTime.hour,
                                pickedTime.minute,
                              );
                              selectedDate = tempSelectedDate;
                            });
                          } else {
                            setDialogState(() {
                              tempSelectedDate = pickedDate;
                              selectedDate = tempSelectedDate;
                            });
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppPallete.gradient1,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Expanded(
                      child: DefaultTabController(
                        length: exercisesByCategory.length,
                        child: Column(
                          children: [
                            TabBar(
                              isScrollable: true,
                              indicatorColor: AppPallete.gradient2,
                              labelColor: AppPallete.gradient2,
                              unselectedLabelColor: const Color.fromARGB(
                                255,
                                80,
                                74,
                                74,
                              ),
                              tabs:
                                  exercisesByCategory.keys
                                      .map(
                                        (cat) => Tab(text: cat.toUpperCase()),
                                      )
                                      .toList(),
                            ),
                            const SizedBox(height: 8),
                            Expanded(
                              child: TabBarView(
                                children:
                                    exercisesByCategory.entries.map((entry) {
                                      final exercises = entry.value;

                                      return ListView.separated(
                                        itemCount: exercises.length,
                                        separatorBuilder:
                                            (_, __) => const Divider(
                                              height: 1,
                                              color: AppPallete.borderColor,
                                            ),
                                        itemBuilder: (context, index) {
                                          final exercise = exercises[index];
                                          final isSelected =
                                              tempSelectedExercises.contains(
                                                exercise,
                                              );

                                          return ListTile(
                                            tileColor:
                                                isSelected
                                                    ? AppPallete.greycard1
                                                        .withOpacity(0.5)
                                                    : null,
                                            leading: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              child: Image.asset(
                                                exercise.image,
                                                width: 48,
                                                height: 48,
                                                fit: BoxFit.cover,
                                                errorBuilder: (
                                                  context,
                                                  error,
                                                  stackTrace,
                                                ) {
                                                  return const Icon(
                                                    Icons.fitness_center,
                                                    size: 48,
                                                    color: AppPallete.gradient2,
                                                  );
                                                },
                                              ),
                                            ),
                                            title: Text(
                                              exercise.name,
                                              style: TextStyle(
                                                fontWeight:
                                                    isSelected
                                                        ? FontWeight.bold
                                                        : FontWeight.normal,
                                                color:
                                                    isSelected
                                                        ? AppPallete.gradient2
                                                        : const Color.fromARGB(
                                                          255,
                                                          0,
                                                          0,
                                                          0,
                                                        ),
                                              ),
                                            ),
                                            subtitle: Text(
                                              exercise.reps ?? 'N/A',
                                              style: TextStyle(
                                                color:
                                                    isSelected
                                                        ? const Color.fromARGB(
                                                          255,
                                                          0,
                                                          0,
                                                          0,
                                                        ).withOpacity(0.8)
                                                        : AppPallete.greyColor,
                                              ),
                                            ),
                                            trailing: Checkbox(
                                              value: isSelected,
                                              onChanged: (checked) {
                                                setDialogState(() {
                                                  if (checked == true) {
                                                    tempSelectedExercises.add(
                                                      exercise,
                                                    );
                                                  } else {
                                                    tempSelectedExercises
                                                        .remove(exercise);
                                                  }
                                                  selectedExercises = List.from(
                                                    tempSelectedExercises,
                                                  );
                                                });
                                              },
                                              activeColor: AppPallete.gradient2,
                                              checkColor: const Color.fromARGB(
                                                255,
                                                65,
                                                55,
                                                55,
                                              ),
                                            ),
                                            onTap: () {
                                              setDialogState(() {
                                                if (isSelected) {
                                                  tempSelectedExercises.remove(
                                                    exercise,
                                                  );
                                                } else {
                                                  tempSelectedExercises.add(
                                                    exercise,
                                                  );
                                                }
                                                selectedExercises = List.from(
                                                  tempSelectedExercises,
                                                );
                                              });
                                            },
                                          );
                                        },
                                      );
                                    }).toList(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text(
                    "Cancel",
                    style: TextStyle(color: Color.fromARGB(255, 4, 4, 4)),
                  ),
                ),
                BlocBuilder<ScheduledWorkoutBloc, ScheduledWorkoutState>(
                  builder: (context, state) {
                    final isLoading = state is ScheduledWorkoutLoading;
                    return ElevatedButton(
                      onPressed:
                          isLoading
                              ? null
                              : () => _handleCreateOrUpdate(workoutToEdit?.id),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppPallete.gradient1,
                      ),
                      child:
                          isLoading
                              ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  color: AppPallete.gradient2,
                                  strokeWidth: 2,
                                ),
                              )
                              : Text(
                                workoutToEdit == null ? "Schedule" : "Update",
                              ),
                    );
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoadingExercises || _currentUser == null) {
      return Scaffold(
        backgroundColor: AppPallete.backgroundColor,
        appBar: AppBar(
          title: const Text('Exercise Schedule'),
          backgroundColor: AppPallete.gradient1,
          elevation: 0,
          actions: [
            if (_currentUser != null)
              IconButton(
                icon: const Icon(Icons.logout, color: AppPallete.whiteColor),
                onPressed: () async {
                  await _supabaseClient.auth.signOut();
                  _showSnackBar('Logged out successfully.');
                },
              ),
          ],
        ),
        body: Center(
          child:
              _currentUser == null
                  ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Please log in to view your workouts.',
                        style: TextStyle(
                          color: AppPallete.whiteColor,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          // Implement navigation to your login page here
                          // Example: Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => LoginPage()));
                          _showSnackBar(
                            'Login button clicked (implement actual navigation).',
                          );
                        },
                        child: const Text('Go to Login'),
                      ),
                    ],
                  )
                  : const CircularProgressIndicator(
                    color: AppPallete.gradient2,
                  ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppPallete.backgroundColor,
      appBar: AppBar(
        title: const Text('Exercise Schedule'),
        backgroundColor: AppPallete.gradient1,
        elevation: 0,
        centerTitle: false,
        actions: [
          if (_currentUser != null)
            IconButton(
              icon: const Icon(Icons.logout, color: AppPallete.whiteColor),
              onPressed: () async {
                await _supabaseClient.auth.signOut();
                _showSnackBar('Logged out successfully.');
              },
            ),
        ],
      ),
      body: BlocConsumer<ScheduledWorkoutBloc, ScheduledWorkoutState>(
        listener: (context, state) {
          if (state is ScheduledWorkoutFailure) {
            _showSnackBar(state.message, isError: true);
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            }
          } else if (state is ScheduledWorkoutSuccess) {
            _showSnackBar(
              'Workout "${state.scheduledWorkout.title}" ${state.scheduledWorkout.id == null ? 'scheduled' : 'updated'} successfully!',
            );
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            }
            if (_currentUser != null) {
              context.read<ScheduledWorkoutBloc>().add(
                FetchAllWorkoutsEvent(_currentUser!.id),
              );
            }
          } else if (state is ScheduledWorkoutDeleteSuccess) {
            _showSnackBar('Workout deleted successfully!');
            if (_currentUser != null) {
              context.read<ScheduledWorkoutBloc>().add(
                FetchAllWorkoutsEvent(_currentUser!.id),
              );
            }
          }
        },
        builder: (context, state) {
          if (state is ScheduledWorkoutLoading &&
              state is! ScheduledWorkoutsDisplaySuccess) {
            return const Center(
              child: CircularProgressIndicator(color: AppPallete.gradient2),
            );
          }

          List<ScheduledWorkout> workoutsToDisplay = [];
          if (state is ScheduledWorkoutsDisplaySuccess) {
            workoutsToDisplay = state.scheduledWorkouts;
          } else if (state is ScheduledWorkoutInitial && _currentUser != null) {
            context.read<ScheduledWorkoutBloc>().add(
              FetchAllWorkoutsEvent(_currentUser!.id),
            );
            return const Center(
              child: CircularProgressIndicator(color: AppPallete.gradient2),
            );
          }

          if (workoutsToDisplay.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "No workouts scheduled yet!",
                    style: TextStyle(fontSize: 18, color: AppPallete.greyColor),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.add),
                    label: const Text("Add New Workout Schedule"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppPallete.gradient2,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 14,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      textStyle: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    onPressed: () => _showScheduleDialog(),
                  ),
                ],
              ),
            );
          }
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.add),
                  label: const Text("Add New Workout Schedule"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 144, 128, 220),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    textStyle: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  onPressed: () => _showScheduleDialog(),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: workoutsToDisplay.length,
                  itemBuilder: (context, index) {
                    final workout = workoutsToDisplay[index];
                    return ScheduledWorkoutCard(
                      workout: workout,
                      onEdit: () => _showScheduleDialog(workoutToEdit: workout),
                      onDelete: () {
                        if (_currentUser == null) {
                          _showSnackBar(
                            'You must be logged in to delete workouts.',
                            isError: true,
                          );
                          return;
                        }
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              backgroundColor: AppPallete.greycard1,
                              title: const Text(
                                'Confirm Deletion',
                                style: TextStyle(color: AppPallete.whiteColor),
                              ),
                              content: Text(
                                'Are you sure you want to delete "${workout.title}"?',
                                style: const TextStyle(
                                  color: AppPallete.whiteColor,
                                ),
                              ),
                              actions: <Widget>[
                                TextButton(
                                  child: const Text(
                                    'Cancel',
                                    style: TextStyle(
                                      color: AppPallete.whiteColor,
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppPallete.errorColor,
                                  ),
                                  child: const Text(
                                    'Delete',
                                    style: TextStyle(
                                      color: AppPallete.whiteColor,
                                    ),
                                  ),
                                  onPressed: () {
                                    context.read<ScheduledWorkoutBloc>().add(
                                      DeleteWorkoutEvent(
                                        workout.id!,
                                        _currentUser!.id,
                                      ),
                                    );
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
