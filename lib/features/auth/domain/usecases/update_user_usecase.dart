import 'package:fitness_app/core/entities/user.dart';
import 'package:fitness_app/core/error/failure.dart';
import 'package:fitness_app/core/usecases/usecase.dart';
import 'package:fitness_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class UpdateUserUsecase implements UseCase<User, UserUpdateParams> {
  final AuthRepository authRepository;

  UpdateUserUsecase({required this.authRepository});

  @override
  Future<Either<Failure, User>> call(UserUpdateParams params) async {
    Map<String, dynamic> data = {
      'gender': params.gender,
      'date_of_birth': params.dob,
      'height': params.height,
      'weight': params.weight,
      'bmi': params.bmi,
      'goal': params.goal,
    };
    return await authRepository.updateUserInfo(data);
  }
}

class UserUpdateParams {
  final String gender;
  final DateTime dob;
  final double weight;
  final double height;
  final double bmi;
  final String goal;

  const UserUpdateParams({
    required this.gender,
    required this.dob,
    required this.weight,
    required this.height,
    required this.bmi,
    required this.goal,
  });
}
