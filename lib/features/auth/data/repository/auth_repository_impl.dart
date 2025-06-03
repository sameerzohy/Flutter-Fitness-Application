import 'package:fitness_app/core/entities/user.dart';
import 'package:fitness_app/core/error/exception.dart';
import 'package:fitness_app/core/error/failure.dart';
import 'package:fitness_app/features/auth/data/remotedatasources/auth_remotedatasource.dart';
import 'package:fitness_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sb;

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatasource authRemoteDatasource;
  const AuthRepositoryImpl({required this.authRemoteDatasource});
  @override
  Future<Either<Failure, User>> getCurrentUser() async {
    try {
      final user = await authRemoteDatasource.getUserData();
      if (user == null) {
        return left(Failure(message: 'User not found'));
      } else {
        return right(user);
      }
    } on ServerException catch (e) {
      return left(Failure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, User>> loginWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      final user = await authRemoteDatasource.loginWithEmailPassword(
        email: email,
        password: password,
      );
      return right(user);
    } on sb.AuthException catch (e) {
      return left(Failure(message: e.message));
    } on ServerException catch (e) {
      return left(Failure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, User>> signupWithEmailPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final user = await authRemoteDatasource.signupWithEmailPassword(
        name: name,
        email: email,
        password: password,
      );
      return right(user);
    } on sb.AuthException catch (e) {
      return left(Failure(message: e.message));
    } on ServerException catch (e) {
      return left(Failure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, User>> updateUserInfo(
    Map<String, dynamic> data,
  ) async {
    try {
      final user = await authRemoteDatasource.updateUserInfo(data);
      if (user == null) return left(Failure(message: 'User not found'));
      return right(user);
    } on sb.AuthException catch (e) {
      return left(Failure(message: e.message));
    } on ServerException catch (e) {
      return left(Failure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await authRemoteDatasource.logout();
      return right(null);
    } on sb.AuthException catch (e) {
      return left(Failure(message: e.message));
    } on ServerException catch (e) {
      return left(Failure(message: e.message));
    }
  }
}
