part of 'meal_utilities_bloc.dart';

@immutable
sealed class MealUtilitiesState {}

final class MealUtilitiesInitial extends MealUtilitiesState {}

class AddMealSuccess extends MealUtilitiesState {
  final List<MealItem> mealList;

  AddMealSuccess({required this.mealList});
}

class AddMealFailure extends MealUtilitiesState {}

class DeleteMealFromSavedSucess extends MealUtilitiesState {
  final List<MealItem> mealList;
  DeleteMealFromSavedSucess({required this.mealList});
}

class DeleteMealFromSavedFailure extends MealUtilitiesState {}

class AddMealComboSuccess extends MealUtilitiesState {}

class AddMealComboFailure extends MealUtilitiesState {}

class UpdateMealComboFailure extends MealUtilitiesState {}

class UpdateMealComboSuccess extends MealUtilitiesState {}

class DeleteMealComboSuccess extends MealUtilitiesState {}

class DeleteMealComboFailure extends MealUtilitiesState {}

class GetMealComboSuccess extends MealUtilitiesState {
  final List<SaveMealCombo> savedMeals;
  GetMealComboSuccess({required this.savedMeals});
}

class GetMealComboFailure extends MealUtilitiesState {
  final String message;

  GetMealComboFailure({required this.message});
}
