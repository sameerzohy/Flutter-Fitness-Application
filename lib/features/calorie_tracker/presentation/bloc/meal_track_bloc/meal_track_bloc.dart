import 'package:fitness_app/core/entities/meal_item.dart';
import 'package:fitness_app/core/usecases/usecase.dart';
import 'package:fitness_app/features/calorie_tracker/domain/usecases/add_meal_local_usecase.dart';
import 'package:fitness_app/features/calorie_tracker/domain/usecases/delete_meal_local_usecase.dart';
import 'package:fitness_app/features/calorie_tracker/domain/usecases/get_meal_local_usecase.dart';
import 'package:fitness_app/features/calorie_tracker/domain/usecases/nutrient_track_usecase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'meal_track_event.dart';
part 'meal_track_state.dart';

class MealTrackBloc extends Bloc<MealTrackEvent, MealTrackState> {
  final AddMealLocalUsecase _addMealLocalUsecase;
  final GetMealLocalUsecase _getMealLocalUsecase;
  final DeleteMealLocalUsecase _deleteMealLocalUsecase;
  final NutrientTrackUsecase _nutrientTrackUsecase;

  Map<String, List<MealItem>> mealCache = {};

  MealTrackBloc({
    required AddMealLocalUsecase addMealLocalUsecase,
    required GetMealLocalUsecase getMealLocalUsecase,
    required DeleteMealLocalUsecase deleteMealLocalUsecase,
    required NutrientTrackUsecase nutrientTrackUsecase,
  }) : _addMealLocalUsecase = addMealLocalUsecase,
       _getMealLocalUsecase = getMealLocalUsecase,
       _deleteMealLocalUsecase = deleteMealLocalUsecase,
       _nutrientTrackUsecase = nutrientTrackUsecase,
       super(MealTrackInitial()) {
    on<AddMealLocal>(_onAddMealLocal);
    on<DeleteMealLocal>(_onDeleteMealLocal);
    on<GetDailyMeals>(_onGetDailyMeals);
    on<GetNutrientInfo>(_onGetNutrientInfo);
  }

  void _onAddMealLocal(AddMealLocal event, Emitter<MealTrackState> emit) async {
    final res = await _addMealLocalUsecase(
      AddMealTrackParam(
        mealItem: event.mealItem,
        mealTime: event.mealTime,
        date: event.date,
      ),
    );
    res.fold((l) => emit(AddMealFailure(message: l.message)), (r) {
      final key = _cacheKey(event.mealTime, event.date);
      mealCache.putIfAbsent(key, () => []);
      mealCache[key]!.add(event.mealItem);
      emit(AddMealSuccess());
      add(GetDailyMeals(date: event.date));
    });
  }

  void _onDeleteMealLocal(
    DeleteMealLocal event,
    Emitter<MealTrackState> emit,
  ) async {
    final res = await _deleteMealLocalUsecase(
      DeleteMealTrackParam(event.date, event.mealTime, event.mealId),
    );
    res.fold((l) => emit(DeleteMealFailure(message: l.message)), (r) {
      final key = _cacheKey(event.mealTime, event.date);
      mealCache[key]?.removeWhere((meal) => meal.mealId == event.mealId);
      emit(DeleteMealSuccess());
      add(GetDailyMeals(date: event.date));
      _onGetDailyMeals(GetDailyMeals(date: event.date), emit);
    });
  }

  void _onGetDailyMeals(
    GetDailyMeals event,
    Emitter<MealTrackState> emit,
  ) async {
    final mealTimes = [
      'BreakFast',
      'Lunch',
      'Dinner',
      'Morning Snack',
      'Evening Snack',
    ];
    List<MealItem> allMeals = [];
    Map<String, List<MealItem>> mealByCategory = {
      'BreakFast': [],
      'Lunch': [],
      'Dinner': [],
      'Morning Snack': [],
      'Evening Snack': [],
      'all_meals': [],
    };

    for (String mealTime in mealTimes) {
      final key = _cacheKey(mealTime, event.date);
      if (mealCache.containsKey(key)) {
        final cachedMeals = mealCache[key]!;
        allMeals.addAll(cachedMeals);
        mealByCategory[mealTime] = cachedMeals; // ✅ Fix here
        continue;
      }

      final res = await _getMealLocalUsecase(
        GetMealTrackParam(mealTime: mealTime, date: event.date),
      );
      res.fold((l) {}, (r) {
        mealCache[key] = r;
        allMeals.addAll(r);
        mealByCategory[mealTime] = r;
      });
    }

    mealByCategory['all_meals'] = allMeals;

    emit(GetDailyMealsSuccess(mealsByCategory: mealByCategory));
  }

  void _onGetNutrientInfo(
    GetNutrientInfo event,
    Emitter<MealTrackState> emit,
  ) async {
    final res = await _nutrientTrackUsecase(NoParams());
    res.fold((l) => emit(GetNutrientInfoFailure(message: l.message)), (r) {
      emit(GetNutrientInfoSuccess(nutrientInfo: r));
    });
  }

  String _cacheKey(String mealTime, DateTime date) =>
      '$mealTime-${date.year}-${date.month}-${date.day}';
}
