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
// import 'package:fitness_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependency() async {
  initAuth();
  final supabase = await Supabase.initialize(
    url: Secrets.url,
    anonKey: Secrets.anonKey,
  );
  // print('supabase Client: ${supabase.client}');

  serviceLocator.registerLazySingleton(() => supabase.client);

  serviceLocator.registerLazySingleton<AppUserCubit>(() => AppUserCubit());
}

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
