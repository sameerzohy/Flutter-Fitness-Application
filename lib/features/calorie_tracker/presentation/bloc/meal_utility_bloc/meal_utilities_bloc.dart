import 'package:bloc/bloc.dart';
import 'package:fitness_app/core/entities/meal_combo.dart';
import 'package:fitness_app/core/entities/meal_item.dart';
import 'package:fitness_app/core/usecases/usecase.dart';
import 'package:fitness_app/features/calorie_tracker/domain/usecases/meal_combo_usecase.dart';
import 'package:flutter/material.dart';

part 'meal_utilities_event.dart';
part 'meal_utilities_state.dart';

class MealUtilitiesBloc extends Bloc<MealUtilitiesEvent, MealUtilitiesState> {
  final AddMealComboUsecase _addMealComboUsecase;
  final DeleteMealComboUsecase _deleteMealComboUsecase;
  final UpdateMealComboUsecase _updateMealComboUsecase;
  final GetMealComboUsecase _getMealComboUsecase;

  MealUtilitiesBloc({
    required AddMealComboUsecase addMealComboUsecase,
    required DeleteMealComboUsecase deleteMealComboUsecase,
    required UpdateMealComboUsecase updateMealComboUsecase,
    required GetMealComboUsecase getMealComboUsecase,
  }) : _addMealComboUsecase = addMealComboUsecase,
       _deleteMealComboUsecase = deleteMealComboUsecase,
       _updateMealComboUsecase = updateMealComboUsecase,
       _getMealComboUsecase = getMealComboUsecase,
       super(MealUtilitiesInitial()) {
    on<AddMealToSaved>(addMealToSaved);
    on<DeleteMealFromSaved>(deleteMealFromSaved);
    on<AddMealComboEvent>(addMealComboEvent);
    on<DeleteMealComboEvent>(deleteMealComboEvent);
    on<UpdateMealComboEvent>(updateMealComboEvent);
    on<GetMealComboEvent>(getMealComboEvent);
  }

  void addMealToSaved(AddMealToSaved event, Emitter<MealUtilitiesState> emit) {
    try {
      emit(AddMealSuccess(mealList: event.addMealList));
    } catch (e) {
      emit(AddMealFailure());
    }
  }

  void deleteMealFromSaved(
    DeleteMealFromSaved event,
    Emitter<MealUtilitiesState> emit,
  ) {
    event.deleteMealList.remove(event.meal);
    try {
      emit(DeleteMealFromSavedSucess(mealList: event.deleteMealList));
    } catch (e) {
      emit(DeleteMealFromSavedFailure());
    }
  }

  void addMealComboEvent(
    AddMealComboEvent event,
    Emitter<MealUtilitiesState> emit,
  ) async {
    final res = await _addMealComboUsecase(event.mealCombo);
    res.fold((l) => emit(AddMealComboFailure()), (r) {
      emit(AddMealComboSuccess());
      add(
        GetMealComboEvent(),
      ); // Dispatch the event instead of calling the method
    });
  }

  void deleteMealComboEvent(
    DeleteMealComboEvent event,
    Emitter<MealUtilitiesState> emit,
  ) async {
    final res = await _deleteMealComboUsecase(event.mealCombo);
    res.fold((l) => emit(DeleteMealComboFailure()), (r) {
      emit(DeleteMealComboSuccess());
      add(GetMealComboEvent());
    });
  }

  void updateMealComboEvent(
    UpdateMealComboEvent event,
    Emitter<MealUtilitiesState> emit,
  ) async {
    final res = await _updateMealComboUsecase(event.mealCombo);
    res.fold((l) => emit(UpdateMealComboFailure()), (r) {
      emit(UpdateMealComboSuccess());
      add(GetMealComboEvent());
    });
  }

  void getMealComboEvent(
    GetMealComboEvent event,
    Emitter<MealUtilitiesState> emit,
  ) async {
    final res = await _getMealComboUsecase(NoParams());
    res.fold(
      (l) => emit(GetMealComboFailure(message: l.message)),
      (r) => emit(GetMealComboSuccess(savedMeals: r)),
    );
  }
}
