part of 'meal_track_bloc.dart';

@immutable
sealed class MealTrackState {}

final class MealTrackInitial extends MealTrackState {}

final class AddMealSuccess extends MealTrackState {}

final class AddMealFailure extends MealTrackState {
  final String message;
  AddMealFailure({required this.message});
}

final class DeleteMealSuccess extends MealTrackState {}

final class DeleteMealFailure extends MealTrackState {
  final String message;
  DeleteMealFailure({required this.message});
}

final class GetMealSuccess extends MealTrackState {
  final List<MealItem> meals;
  final String mealTime;
  GetMealSuccess({required this.meals, required this.mealTime});
}

final class GetMealFailure extends MealTrackState {
  final String message;
  final String mealTime;
  GetMealFailure({required this.message, required this.mealTime});
}

final class GetDailyMealsSuccess extends MealTrackState {
  final Map<String, List<MealItem>> mealsByCategory;
  GetDailyMealsSuccess({required this.mealsByCategory});
}

final class GetNutrientInfoSuccess extends MealTrackState {
  final Map<DateTime, Map<String, dynamic>> nutrientInfo;
  GetNutrientInfoSuccess({required this.nutrientInfo});
}

final class GetNutrientInfoFailure extends MealTrackState {
  final String message;
  GetNutrientInfoFailure({required this.message});
}
