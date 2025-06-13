import 'package:fitness_app/features/exercise_tracker/data/datasources/scheduled_workout_remote_data_source.dart';
import 'package:fitness_app/features/exercise_tracker/data/datasources/workout_local_datasource.dart';
import 'package:fitness_app/features/exercise_tracker/data/datasources/workout_remote_datasource.dart';
import 'package:fitness_app/features/exercise_tracker/data/repositories/exercises_repository_impl.dart';
import 'package:fitness_app/features/exercise_tracker/data/repositories/scheduled_workout_repository_impl.dart';

import 'package:fitness_app/features/exercise_tracker/data/repositories/workout_repository_impl.dart';
import 'package:fitness_app/features/exercise_tracker/domain/repositories/exercises_repository.dart';
import 'package:fitness_app/features/exercise_tracker/domain/repositories/scheduled_workout_repository.dart';
import 'package:fitness_app/features/exercise_tracker/domain/repositories/workout_repository.dart';
import 'package:fitness_app/features/exercise_tracker/domain/usecases/schedule_usecases/create_scheduled_workout.dart';
import 'package:fitness_app/features/exercise_tracker/domain/usecases/schedule_usecases/delete_scheduled_workout.dart';
// IMPORTANT: Assuming GetScheduledWorkouts is your FetchAllScheduledWorkouts use case class
import 'package:fitness_app/features/exercise_tracker/domain/usecases/schedule_usecases/get_scheduled_workouts.dart'; // Renamed to FetchAllScheduledWorkouts in the bloc?
import 'package:fitness_app/features/exercise_tracker/domain/usecases/schedule_usecases/update_scheduled_workout.dart';
import 'package:fitness_app/features/exercise_tracker/domain/usecases/workout_usecases/clear_workout_history.dart';
import 'package:fitness_app/features/exercise_tracker/domain/usecases/workout_usecases/delete_workout_history.dart';
import 'package:fitness_app/features/exercise_tracker/domain/usecases/workout_usecases/load_all_workout_history.dart';
import 'package:fitness_app/features/exercise_tracker/domain/usecases/workout_usecases/load_workout_history.dart';
import 'package:fitness_app/features/exercise_tracker/domain/usecases/workout_usecases/save_workout_history.dart';
import 'package:fitness_app/features/exercise_tracker/domain/usecases/workout_usecases/update_workout_history.dart';
import 'package:fitness_app/features/exercise_tracker/presentation/blocs/scheduled_workout/scheduled_workout_bloc.dart';
import 'package:fitness_app/features/exercise_tracker/presentation/blocs/workout_history_bloc/workout_history_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart'; // Required for WidgetsFlutterBinding.ensureInitialized();

// --- Workout History Imports ---

// --- Auth Imports ---
import 'package:fitness_app/core/secrets/secrets.dart';
import 'package:fitness_app/core/cubits/cubit/app_user_cubit.dart';
import 'package:fitness_app/features/auth/data/remotedatasources/auth_remotedatasource.dart';
import 'package:fitness_app/features/auth/data/repository/auth_repository_impl.dart';
import 'package:fitness_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:fitness_app/features/auth/domain/usecases/current_user_usecase.dart';
import 'package:fitness_app/features/auth/domain/usecases/update_user_usecase.dart';
import 'package:fitness_app/features/auth/domain/usecases/user_login_usecase.dart';
import 'package:fitness_app/features/auth/domain/usecases/user_logout_usecase.dart';
import 'package:fitness_app/features/auth/domain/usecases/user_signup_usecase.dart';
import 'package:fitness_app/features/auth/presentation/bloc/auth_bloc.dart';

// --- NEW SCHEDULING FEATURE IMPORTS ---
// Make sure to import the specific use case you need for fetching all exercises
import 'package:fitness_app/features/exercise_tracker/domain/usecases/schedule_usecases/fetch_exercises.dart';


final sl = GetIt.instance; // Using your 'sl' instance

Future<void> initDependency() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure this is called early
  await Hive.openBox<List>('workout_history');
  await Hive.openBox('meta_box');
  await _initSupabase(); // This initializes Supabase client and registers it with sl
  _initExternal();
  _initAuth();
  _initWorkoutHistory();
  _initExercisesRepository(); // NEW: Initialize the ExercisesRepository
  _initScheduling(); // NEW: Initialize the Scheduling feature
}

/// Supabase Initialization
Future<void> _initSupabase() async {
  final supabase = await Supabase.initialize(
    url: Secrets.url,
    anonKey: Secrets.anonKey,
  );
  sl.registerLazySingleton<SupabaseClient>(() => supabase.client);
}

/// External and Shared Dependencies
void _initExternal() {
  sl.registerLazySingleton<Box<List>>(() => Hive.box<List>('workout_history'));
  sl.registerLazySingleton<Box>(() => Hive.box('meta_box'));
  sl.registerLazySingleton(() => const Uuid());
  sl.registerLazySingleton<AppUserCubit>(() => AppUserCubit());
}

/// Auth DI
void _initAuth() {
  sl.registerFactory<AuthRemoteDatasource>(
    () => AuthRemoteDataSourceImpl(supabaseClient: sl()),
  );
  sl.registerFactory<AuthRepository>(
    () => AuthRepositoryImpl(authRemoteDatasource: sl()),
  );
  sl.registerFactory<UserSignupUsecase>(() => UserSignupUsecase(authRepository: sl()));
  sl.registerFactory<UserLoginUseCase>(() => UserLoginUseCase(authRepository: sl()));
  sl.registerFactory<CurrentUser>(() => CurrentUser(sl()));
  sl.registerFactory<UpdateUserUsecase>(() => UpdateUserUsecase(authRepository: sl()));
  sl.registerFactory<UserLogoutUsecase>(() => UserLogoutUsecase(sl()));

  sl.registerLazySingleton<AuthBloc>(
    () => AuthBloc(
      userLoginUseCase: sl(),
      userSignupUsecase: sl(),
      currentUser: sl(),
      appUserCubit: sl(),
      updateUserUsecase: sl(),
      userLogoutUsecase: sl(),
    ),
  );
}

/// Workout History DI
void _initWorkoutHistory() {
  // Bloc
  sl.registerFactory(() => WorkoutHistoryBloc(
        loadWorkoutHistoryUseCase: sl(),
        loadAllWorkoutHistoryUseCase: sl(),
        saveWorkoutHistoryUseCase: sl(),
        updateWorkoutHistoryUseCase: sl(),
        deleteWorkoutHistoryUseCase: sl(),
        clearWorkoutHistoryUseCase: sl(),
      ));

  // Use Cases
  sl.registerLazySingleton(() => LoadWorkoutHistory(sl()));
  sl.registerLazySingleton(() => SaveWorkoutHistory(sl()));
  sl.registerLazySingleton(() => LoadAllWorkoutHistory(sl()));
  sl.registerLazySingleton(() => UpdateWorkoutHistory(sl()));
  sl.registerLazySingleton(() => DeleteWorkoutHistory(sl()));
  sl.registerLazySingleton(() => ClearWorkoutHistory(sl()));

  // Repository
  sl.registerLazySingleton<WorkoutRepository>(
    () => WorkoutRepositoryImpl(
      localDataSource: sl(),
      remoteDataSource: sl(),
    ),
  );

  // Data Sources
  sl.registerLazySingleton<WorkoutLocalDataSource>(
    () => WorkoutLocalDataSourceImpl(
      historyBox: sl(),
      metaBox: sl(),
    ),
  );
  sl.registerLazySingleton<WorkoutRemoteDataSource>(
    () => WorkoutRemoteDataSourceImpl(
      supabaseClient: sl(),
      uuid: sl(),
    ),
  );
}

/// NEW: Exercises Repository DI
void _initExercisesRepository() {
  sl.registerLazySingleton<ExercisesRepository>(
    () => ExercisesRepositoryImpl(), // This will be your actual ExercisesRepositoryImpl
  );
}

/// NEW: Scheduling Feature DI
void _initScheduling() {
  // Data sources
  sl.registerLazySingleton<ScheduledWorkoutRemoteDataSource>(
    () => ScheduledWorkoutRemoteDataSourceImpl(
      sl(), // SupabaseClient
    ),
  );

  // Repositories
  sl.registerLazySingleton<ScheduledWorkoutRepository>(
    () => ScheduledWorkoutRepositoryImpl(sl()), // ScheduledWorkoutRemoteDataSource
  );

  // Use cases
  sl.registerLazySingleton(
    () => CreateScheduledWorkout(sl()),
  );

  // Register the use case to fetch ALL *scheduled* workouts.
  // Based on your comment, 'GetScheduledWorkouts' seems to be this.
  sl.registerLazySingleton(
    () => FetchAllScheduledWorkouts(sl()),
  );

  sl.registerLazySingleton(
    () => UpdateScheduledWorkout(sl()),
  );
  sl.registerLazySingleton(
    () => DeleteScheduledWorkout(sl()),
  );

  // --- Crucial addition for ExerciseSchedulePage ---
  // Register the use case to fetch all available *exercises* for selection.
  sl.registerLazySingleton<FetchExercises>(
    () => FetchExercises(sl()), // FetchExercises depends on ExercisesRepository
  );
  // -------------------------------------------------

  // BLoC
  sl.registerFactory(
    () => ScheduledWorkoutBloc(
      createScheduledWorkout: sl(),
      updateScheduledWorkout: sl(),
      deleteScheduledWorkout: sl(),
      // Ensure this matches the type in your BLoC constructor.
      // If the bloc expects FetchAllScheduledWorkouts, and GetScheduledWorkouts is it, then this is correct.
      fetchAllScheduledWorkouts: sl<FetchAllScheduledWorkouts>(),
      supabaseClient: sl(),
    ),
  );
}