part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

final class AuthUserIsLoggedIn extends AuthEvent {}

final class AuthLogOut extends AuthEvent {}

final class AuthLogIn extends AuthEvent {
  final String email;
  final String password;

  AuthLogIn({required this.email, required this.password});
}

final class AuthSignUp extends AuthEvent {
  final String name;
  final String email;
  final String password;

  AuthSignUp({required this.name, required this.email, required this.password});
}

final class UpdateUser extends AuthEvent {
  final DateTime dob;
  final String gender;
  final double height;
  final double weight;
  final String goal;
  final double bmi;

  UpdateUser({
    required this.dob,
    required this.gender,
    required this.height,
    required this.weight,
    required this.goal,
    required this.bmi,
  });
}
