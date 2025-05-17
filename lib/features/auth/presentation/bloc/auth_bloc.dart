import 'package:fitness_app/core/cubits/cubit/app_user_cubit.dart';
import 'package:fitness_app/core/entities/user.dart';
import 'package:fitness_app/core/usecases/usecase.dart';
import 'package:fitness_app/features/auth/domain/usecases/current_user_usecase.dart';
import 'package:fitness_app/features/auth/domain/usecases/update_user_usecase.dart';
import 'package:fitness_app/features/auth/domain/usecases/user_login_usecase.dart';
import 'package:fitness_app/features/auth/domain/usecases/user_logout_usecase.dart';
import 'package:fitness_app/features/auth/domain/usecases/user_signup_usecase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserLoginUseCase _userLoginUseCase;
  final UserSignupUsecase _userSignupUsecase;
  final CurrentUser _currentUser;
  final AppUserCubit _appUserCubit;
  final UpdateUserUsecase _updateUserUsecase;
  final UserLogoutUsecase _userLogoutUsecase;

  AuthBloc({
    required UserLoginUseCase userLoginUseCase,
    required UserSignupUsecase userSignupUsecase,
    required CurrentUser currentUser,
    required AppUserCubit appUserCubit,
    required UpdateUserUsecase updateUserUsecase,
    required UserLogoutUsecase userLogoutUsecase,
  }) : _userLoginUseCase = userLoginUseCase,
       _userSignupUsecase = userSignupUsecase,
       _currentUser = currentUser,
       _appUserCubit = appUserCubit,
       _updateUserUsecase = updateUserUsecase,
       _userLogoutUsecase = userLogoutUsecase,
       super(AuthInitial()) {
    on<AuthLogIn>(_onAuthLogIn);
    on<AuthSignUp>(_onAuthSignUp);
    on<AuthUserIsLoggedIn>(_onAuthUserIsLoggedIn);
    on<UpdateUser>(_onUpdateUser);
    on<AuthLogOut>(_onAuthLogout);
  }

  void _onAuthLogIn(AuthLogIn event, Emitter<AuthState> emit) async {
    // emit(AuthLoading());
    _appUserCubit.appUserLoader();
    final res = await _userLoginUseCase(
      UserLoginParams(email: event.email, password: event.password),
    );

    res.fold((l) => _emitAuthFailure(l.message, emit), (user) {
      _emitAuthSuccess(user, emit);
    });
  }

  void _onAuthSignUp(AuthSignUp event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final res = await _userSignupUsecase(
      UserSignUpParams(
        name: event.name,
        email: event.email,
        password: event.password,
      ),
    );
    res.fold(
      (l) {
        print(l);
        emit(AuthFailure(message: l.message));
      },
      (user) {
        print(user);
        emit(AuthSuccess(user));
        _appUserCubit.appLogInPage();
      },
    );
  }

  void _onAuthUserIsLoggedIn(
    AuthUserIsLoggedIn event,
    Emitter<AuthState> emit,
  ) async {
    final res = await _currentUser(NoParams());
    print(res);
    res.fold((l) => _emitAuthFailure(l.message, emit), (user) {
      _emitAuthSuccess(user, emit);
    });
  }

  void _onUpdateUser(UpdateUser event, Emitter<AuthState> emit) async {
    // _appUserCubit.appUserLoader();
    final res = await _updateUserUsecase(
      UserUpdateParams(
        gender: event.gender,
        dob: event.dob,
        weight: event.weight,
        height: event.height,
        bmi: event.bmi,
        goal: event.goal,
      ),
    );
    print(res);

    res.fold(
      (l) => _emitAuthFailure(l.message, emit),
      (user) => _emitAuthSuccess(user, emit),
    );
  }

  void _onAuthLogout(AuthLogOut event, Emitter<AuthState> emit) async {
    await _userLogoutUsecase(NoParams());
    _appUserCubit.loadInitial();
    emit(AuthInitial());
  }

  void _emitAuthFailure(String msg, Emitter<AuthState> emit) {
    _appUserCubit.loadInitial();
    emit(AuthFailure(message: msg));
  }

  void _emitAuthSuccess(User user, Emitter<AuthState> emit) {
    _appUserCubit.updateUser(user);
    print('Emitting Loader');
    // _appUserCubit.appUserLoader();
    emit(AuthSuccess(user));
  }
}
