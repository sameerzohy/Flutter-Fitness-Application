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
import 'package:fitness_app/features/exercise_tracker/domain/usecases/schedule_usecases/get_scheduled_workouts.dart';
import 'package:fitness_app/features/exercise_tracker/domain/usecases/schedule_usecases/update_scheduled_workout.dart';
import 'package:fitness_app/features/exercise_tracker/domain/usecases/schedule_usecases/fetch_exercises.dart';
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
import 'package:flutter/material.dart';

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

import 'package:fitness_app/features/calorie_tracker/data/hive_models/hive_meal_item.dart';
import 'package:fitness_app/features/calorie_tracker/data/local_datasource/local_datasource.dart';
import 'package:fitness_app/features/calorie_tracker/data/remotedatasources/nutrient_track_remote_datasource.dart';
import 'package:fitness_app/features/calorie_tracker/data/remotedatasources/save_meal_combo_remote.dart';
import 'package:fitness_app/features/calorie_tracker/data/repositories/meal_track_local_repository.dart';
import 'package:fitness_app/features/calorie_tracker/data/repositories/nutrient_track_repository_impl.dart';
import 'package:fitness_app/features/calorie_tracker/data/repositories/save_meal_combo.dart';
import 'package:fitness_app/features/calorie_tracker/domain/repositories/meal_track_local_repository.dart';
import 'package:fitness_app/features/calorie_tracker/domain/repositories/nutrient_track_repo.dart';
import 'package:fitness_app/features/calorie_tracker/domain/repositories/save_meal_combo.dart';
import 'package:fitness_app/features/calorie_tracker/domain/usecases/add_meal_local_usecase.dart';
import 'package:fitness_app/features/calorie_tracker/domain/usecases/delete_meal_local_usecase.dart';
import 'package:fitness_app/features/calorie_tracker/domain/usecases/get_meal_local_usecase.dart';
import 'package:fitness_app/features/calorie_tracker/domain/usecases/meal_combo_usecase.dart';
import 'package:fitness_app/features/calorie_tracker/domain/usecases/nutrient_track_usecase.dart';
import 'package:fitness_app/features/calorie_tracker/presentation/bloc/meal_track_bloc/meal_track_bloc.dart';
import 'package:fitness_app/features/calorie_tracker/presentation/bloc/meal_utility_bloc/meal_utilities_bloc.dart';

final sl = GetIt.instance;

Future<void> initDependency() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.openBox<List>('workout_history');
  await Hive.openBox('meta_box');

  await _initSupabase();
  _initExternal();
  _initAuth();
  _initWorkoutHistory();
  _initExercisesRepository();
  _initScheduling();
  _initMealTracking();
}

Future<void> _initSupabase() async {
  final supabase = await Supabase.initialize(
    url: Secrets.url,
    anonKey: Secrets.anonKey,
  );
  sl.registerLazySingleton<SupabaseClient>(() => supabase.client);
}

void _initExternal() {
  sl.registerLazySingleton<Box<List>>(() => Hive.box<List>('workout_history'));
  sl.registerLazySingleton<Box>(() => Hive.box('meta_box'));
  sl.registerLazySingleton(() => const Uuid());
  sl.registerLazySingleton<AppUserCubit>(() => AppUserCubit());
}

void _initAuth() {
  sl.registerFactory<AuthRemoteDatasource>(() => AuthRemoteDataSourceImpl(supabaseClient: sl()));
  sl.registerFactory<AuthRepository>(() => AuthRepositoryImpl(authRemoteDatasource: sl()));
  sl.registerFactory<UserSignupUsecase>(() => UserSignupUsecase(authRepository: sl()));
  sl.registerFactory<UserLoginUseCase>(() => UserLoginUseCase(authRepository: sl()));
  sl.registerFactory<CurrentUser>(() => CurrentUser(sl()));
  sl.registerFactory<UpdateUserUsecase>(() => UpdateUserUsecase(authRepository: sl()));
  sl.registerFactory<UserLogoutUsecase>(() => UserLogoutUsecase(sl()));
  sl.registerLazySingleton<AuthBloc>(() => AuthBloc(
        userLoginUseCase: sl(),
        userSignupUsecase: sl(),
        currentUser: sl(),
        appUserCubit: sl(),
        updateUserUsecase: sl(),
        userLogoutUsecase: sl(),
      ));
}

void _initWorkoutHistory() {
  sl.registerFactory(() => WorkoutHistoryBloc(
        loadWorkoutHistoryUseCase: sl(),
        loadAllWorkoutHistoryUseCase: sl(),
        saveWorkoutHistoryUseCase: sl(),
        updateWorkoutHistoryUseCase: sl(),
        deleteWorkoutHistoryUseCase: sl(),
        clearWorkoutHistoryUseCase: sl(),
      ));

  sl.registerLazySingleton(() => LoadWorkoutHistory(sl()));
  sl.registerLazySingleton(() => SaveWorkoutHistory(sl()));
  sl.registerLazySingleton(() => LoadAllWorkoutHistory(sl()));
  sl.registerLazySingleton(() => UpdateWorkoutHistory(sl()));
  sl.registerLazySingleton(() => DeleteWorkoutHistory(sl()));
  sl.registerLazySingleton(() => ClearWorkoutHistory(sl()));

  sl.registerLazySingleton<WorkoutRepository>(
    () => WorkoutRepositoryImpl(localDataSource: sl(), remoteDataSource: sl()),
  );

  sl.registerLazySingleton<WorkoutLocalDataSource>(
    () => WorkoutLocalDataSourceImpl(historyBox: sl(), metaBox: sl()),
  );

  sl.registerLazySingleton<WorkoutRemoteDataSource>(
    () => WorkoutRemoteDataSourceImpl(supabaseClient: sl(), uuid: sl()),
  );
}

void _initExercisesRepository() {
  sl.registerLazySingleton<ExercisesRepository>(() => ExercisesRepositoryImpl());
}

void _initScheduling() {
  sl.registerLazySingleton<ScheduledWorkoutRemoteDataSource>(
      () => ScheduledWorkoutRemoteDataSourceImpl(sl()));

  sl.registerLazySingleton<ScheduledWorkoutRepository>(
      () => ScheduledWorkoutRepositoryImpl(sl()));

  sl.registerLazySingleton(() => CreateScheduledWorkout(sl()));
  sl.registerLazySingleton(() => FetchAllScheduledWorkouts(sl()));
  sl.registerLazySingleton(() => UpdateScheduledWorkout(sl()));
  sl.registerLazySingleton(() => DeleteScheduledWorkout(sl()));

  sl.registerLazySingleton<FetchExercises>(() => FetchExercises(sl()));

  sl.registerFactory(() => ScheduledWorkoutBloc(
        createScheduledWorkout: sl(),
        updateScheduledWorkout: sl(),
        deleteScheduledWorkout: sl(),
        fetchAllScheduledWorkouts: sl<FetchAllScheduledWorkouts>(),
        supabaseClient: sl(),
      ));
}

void _initMealTracking() {
  sl.registerLazySingleton(() => Hive.box<HiveMealItem>('daily_meal_box'));

  sl.registerFactory<MealTrackLocalDataSource>(() => MealTrackLocalDataSourceImpl(sl()));
  sl.registerFactory<MealTrackLocalRepository>(() => MealTrackLocalReposityImpl(sl()));
  sl.registerFactory<AddMealLocalUsecase>(() => AddMealLocalUsecase(sl()));
  sl.registerFactory<GetMealLocalUsecase>(() => GetMealLocalUsecase(sl()));
  sl.registerFactory<DeleteMealLocalUsecase>(() => DeleteMealLocalUsecase(sl()));
  sl.registerFactory<NutrientTrackRemoteDataSource>(() => NutrientTrackRemoteDataSourceImpl(sl()));
  sl.registerFactory<NutrientTrackRepository>(() => NutrientTrackRepositoryImpl(sl()));
  sl.registerFactory<NutrientTrackUsecase>(() => NutrientTrackUsecase(sl()));

  sl.registerLazySingleton<MealTrackBloc>(() => MealTrackBloc(
        addMealLocalUsecase: sl(),
        getMealLocalUsecase: sl(),
        deleteMealLocalUsecase: sl(),
        nutrientTrackUsecase: sl(),
      ));

  sl.registerFactory<SaveMealComboRemote>(() => SaveMealComboRemoteImpl(sl()));
  sl.registerFactory<SaveMealComboRepository>(() => SaveMealComboRepositoryImpl(saveMealComboRemote: sl()));
  sl.registerFactory<AddMealComboUsecase>(() => AddMealComboUsecase(repository: sl()));
  sl.registerFactory<GetMealComboUsecase>(() => GetMealComboUsecase(repository: sl()));
  sl.registerFactory<DeleteMealComboUsecase>(() => DeleteMealComboUsecase(repository: sl()));
  sl.registerFactory<UpdateMealComboUsecase>(() => UpdateMealComboUsecase(repository: sl()));

  sl.registerLazySingleton<MealUtilitiesBloc>(() => MealUtilitiesBloc(
        addMealComboUsecase: sl(),
        getMealComboUsecase: sl(),
        deleteMealComboUsecase: sl(),
        updateMealComboUsecase: sl(),
      ));
}
