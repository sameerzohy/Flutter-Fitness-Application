import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fitness_app/core/entities/user.dart';

part 'app_user_state.dart';

class AppUserCubit extends Cubit<AppUserState> {
  AppUserCubit() : super(AppUserLoading());

  void updateUser(User user) {
    emit(AppUserLoading());

    if (user.height == null ||
        user.weight == null ||
        user.date_of_birth == null ||
        user.gender == null ||
        user.bmi == null ||
        user.goal == null) {
      emit(AppGetUserInfo());
    } else {
      emit(AppUserIsLoggedIn());
    }
  }

  void loadInitial() {
    emit(AppLogInPage());
  }

  void appUserLoader() {
    emit(AppUserLoading());
  }

  void appLogInPage() {
    emit(AppLogInPage());
  }

  void appSignupPage() {
    emit(AppSignUpPage());
  }

  void appUserGetInfo() {
    // print('Loading Getuser Info');
    emit(AppGetUserInfo());
  }
}
