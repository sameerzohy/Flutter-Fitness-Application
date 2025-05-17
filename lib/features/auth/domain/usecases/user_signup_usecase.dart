import 'package:fitness_app/core/entities/user.dart';
import 'package:fitness_app/core/error/failure.dart';
import 'package:fitness_app/core/usecases/usecase.dart';
import 'package:fitness_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class UserSignupUsecase implements UseCase<User, UserSignUpParams> {
  final AuthRepository authRepository;
  const UserSignupUsecase({required this.authRepository});
  @override
  Future<Either<Failure, User>> call(UserSignUpParams params) async {
    return await authRepository.signupWithEmailPassword(
      name: params.name,
      email: params.email,
      password: params.password,
    );
  }
}

class UserSignUpParams {
  final String name;
  final String password;
  final String email;

  UserSignUpParams({
    required this.name,
    required this.password,
    required this.email,
  });
}
