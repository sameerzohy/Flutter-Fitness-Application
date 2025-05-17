import 'package:fitness_app/core/entities/user.dart';
import 'package:fpdart/fpdart.dart';
import 'package:fitness_app/core/error/failure.dart';

abstract interface class AuthRepository {
  Future<Either<Failure, User>> loginWithEmailPassword({
    required String email,
    required String password,
  });

  Future<Either<Failure, User>> signupWithEmailPassword({
    required String name,
    required String email,
    required String password,
  });

  Future<Either<Failure, User>> getCurrentUser();

  Future<Either<Failure, User>> updateUserInfo(Map<String, dynamic> data);

  Future<Either<Failure, void>> logout();
}
