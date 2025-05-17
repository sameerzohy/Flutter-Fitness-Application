import 'package:fitness_app/core/error/failure.dart';
import 'package:fitness_app/core/usecases/usecase.dart';
import 'package:fitness_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class UserLogoutUsecase implements UseCase<void, NoParams> {
  final AuthRepository authrepository;
  const UserLogoutUsecase(this.authrepository);

  @override
  Future<Either<Failure, void>> call(NoParams params) {
    return authrepository.logout();
  }
}
