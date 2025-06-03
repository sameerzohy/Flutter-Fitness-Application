part of 'meal_utilities_bloc.dart';

@immutable
sealed class MealUtilitiesEvent {}

class AddMealToSaved extends MealUtilitiesEvent {
  final List<MealItem> addMealList;
  AddMealToSaved({required this.addMealList});
}

class DeleteMealFromSaved extends MealUtilitiesEvent {
  final List<MealItem> deleteMealList;
  final MealItem meal;
  DeleteMealFromSaved({required this.deleteMealList, required this.meal});
}

class AddMealComboEvent extends MealUtilitiesEvent {
  final SaveMealCombo mealCombo;
  AddMealComboEvent({required this.mealCombo});
}

class DeleteMealComboEvent extends MealUtilitiesEvent {
  final SaveMealCombo mealCombo;
  DeleteMealComboEvent({required this.mealCombo});
}

class UpdateMealComboEvent extends MealUtilitiesEvent {
  final SaveMealCombo mealCombo;
  UpdateMealComboEvent({required this.mealCombo});
}

class GetMealComboEvent extends MealUtilitiesEvent {}
