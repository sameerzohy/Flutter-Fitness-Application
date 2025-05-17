part of 'app_user_cubit.dart';

@immutable
sealed class AppUserState {}

final class AppUserInitial extends AppUserState {}

final class AppUserIsLoggedIn extends AppUserState {}

final class AppGetUserInfo extends AppUserState {}

final class AppUserLoading extends AppUserState {}

final class AppSignUpPage extends AppUserState {}

final class AppLogInPage extends AppUserState {}
