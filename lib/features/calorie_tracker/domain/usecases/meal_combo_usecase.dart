import 'package:fitness_app/core/entities/meal_combo.dart';
import 'package:fitness_app/core/error/failure.dart';
import 'package:fitness_app/core/usecases/usecase.dart';
import 'package:fitness_app/features/calorie_tracker/domain/repositories/save_meal_combo.dart';
import 'package:fpdart/fpdart.dart';

class AddMealComboUsecase implements UseCase<void, SaveMealCombo> {
  final SaveMealComboRepository repository;
  AddMealComboUsecase({required this.repository});

  @override
  Future<Either<Failure, void>> call(params) async {
    return await repository.addMealCombo(params);
  }
}

class UpdateMealComboUsecase implements UseCase<void, SaveMealCombo> {
  final SaveMealComboRepository repository;
  UpdateMealComboUsecase({required this.repository});

  @override
  Future<Either<Failure, void>> call(params) async {
    return await repository.updateMealCombo(params);
  }
}

class GetMealComboUsecase implements UseCase<List<SaveMealCombo>, NoParams> {
  final SaveMealComboRepository repository;
  GetMealComboUsecase({required this.repository});

  @override
  Future<Either<Failure, List<SaveMealCombo>>> call(params) async {
    return await repository.getMealcombo();
  }
}

class DeleteMealComboUsecase implements UseCase<void, SaveMealCombo> {
  final SaveMealComboRepository repository;
  DeleteMealComboUsecase({required this.repository});

  @override
  Future<Either<Failure, void>> call(params) async {
    return await repository.deleteMealCombo(params);
  }
}
