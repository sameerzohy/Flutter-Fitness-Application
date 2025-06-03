import 'package:fitness_app/core/cubits/cubit/app_user_cubit.dart';
import 'package:fitness_app/core/secrets/secrets.dart';
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
// import 'package:fitness_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependency() async {
  initAuth();
  mealTrack();
  final supabase = await Supabase.initialize(
    url: Secrets.url,
    anonKey: Secrets.anonKey,
  );
  // print('supabase Client: ${supabase.client}');

  serviceLocator.registerLazySingleton(() => supabase.client);

  serviceLocator.registerLazySingleton(
    () => Hive.box<HiveMealItem>('daily_meal_box'),
  );

  serviceLocator.registerLazySingleton<AppUserCubit>(() => AppUserCubit());
}

void mealTrack() {
  serviceLocator.registerFactory<MealTrackLocalDataSource>(
    () => MealTrackLocalDataSourceImpl(serviceLocator()),
  );

  serviceLocator.registerFactory<MealTrackLocalRepository>(
    () => MealTrackLocalReposityImpl(serviceLocator()),
  );

  serviceLocator.registerFactory<AddMealLocalUsecase>(
    () => AddMealLocalUsecase(serviceLocator()),
  );

  serviceLocator.registerFactory<GetMealLocalUsecase>(
    () => GetMealLocalUsecase(serviceLocator()),
  );

  serviceLocator.registerFactory<DeleteMealLocalUsecase>(
    () => DeleteMealLocalUsecase(serviceLocator()),
  );

  serviceLocator.registerFactory<NutrientTrackRemoteDataSource>(
    () => NutrientTrackRemoteDataSourceImpl(serviceLocator()),
  );

  serviceLocator.registerFactory<NutrientTrackRepository>(
    () => NutrientTrackRepositoryImpl(serviceLocator()),
  );

  serviceLocator.registerFactory<NutrientTrackUsecase>(
    () => NutrientTrackUsecase(serviceLocator()),
  );

  serviceLocator.registerLazySingleton<MealTrackBloc>(
    () => MealTrackBloc(
      addMealLocalUsecase: serviceLocator(),
      getMealLocalUsecase: serviceLocator(),
      deleteMealLocalUsecase: serviceLocator(),
      nutrientTrackUsecase: serviceLocator(),
    ),
  );

  serviceLocator.registerFactory<SaveMealComboRemote>(
    () => SaveMealComboRemoteImpl(serviceLocator()),
  );

  serviceLocator.registerFactory<SaveMealComboRepository>(
    () => SaveMealComboRepositoryImpl(saveMealComboRemote: serviceLocator()),
  );

  serviceLocator.registerFactory<AddMealComboUsecase>(
    () => AddMealComboUsecase(repository: serviceLocator()),
  );

  serviceLocator.registerFactory<GetMealComboUsecase>(
    () => GetMealComboUsecase(repository: serviceLocator()),
  );

  serviceLocator.registerFactory<DeleteMealComboUsecase>(
    () => DeleteMealComboUsecase(repository: serviceLocator()),
  );

  serviceLocator.registerFactory<UpdateMealComboUsecase>(
    () => UpdateMealComboUsecase(repository: serviceLocator()),
  );

  serviceLocator.registerLazySingleton<MealUtilitiesBloc>(
    () => MealUtilitiesBloc(
      addMealComboUsecase: serviceLocator(),
      getMealComboUsecase: serviceLocator(),
      deleteMealComboUsecase: serviceLocator(),
      updateMealComboUsecase: serviceLocator(),
    ),
  );
}

class MealTrackRepository {}

void initAuth() {
  serviceLocator
    ..registerFactory<AuthRemoteDatasource>(
      () => AuthRemoteDataSourceImpl(supabaseClient: serviceLocator()),
    )
    ..registerFactory<AuthRepository>(
      () => AuthRepositoryImpl(authRemoteDatasource: serviceLocator()),
    )
    ..registerFactory<UserSignupUsecase>(
      () => UserSignupUsecase(authRepository: serviceLocator()),
    )
    ..registerFactory<UserLoginUseCase>(
      () => UserLoginUseCase(authRepository: serviceLocator()),
    )
    ..registerFactory<CurrentUser>(() => CurrentUser(serviceLocator()))
    ..registerFactory<UpdateUserUsecase>(
      () => UpdateUserUsecase(authRepository: serviceLocator()),
    )
    ..registerFactory<UserLogoutUsecase>(
      () => UserLogoutUsecase(serviceLocator()),
    )
    ..registerLazySingleton<AuthBloc>(
      () => AuthBloc(
        userLoginUseCase: serviceLocator(),
        userSignupUsecase: serviceLocator(),
        currentUser: serviceLocator(),
        appUserCubit: serviceLocator(),
        updateUserUsecase: serviceLocator(),
        userLogoutUsecase: serviceLocator(),
      ),
    );
}
