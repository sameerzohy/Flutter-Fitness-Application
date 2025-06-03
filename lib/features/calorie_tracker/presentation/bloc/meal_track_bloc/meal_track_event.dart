part of 'meal_track_bloc.dart';

@immutable
sealed class MealTrackEvent {}

final class AddMealLocal extends MealTrackEvent {
  final MealItem mealItem;
  final String mealTime;
  final DateTime date;
  AddMealLocal({
    required this.mealItem,
    required this.mealTime,
    required this.date,
  });
}

final class GetMealByTime extends MealTrackEvent {
  final String mealTime;
  final DateTime date;
  GetMealByTime({required this.mealTime, required this.date});
}

final class DeleteMealLocal extends MealTrackEvent {
  final DateTime date;
  final String mealTime;
  final String mealId;
  DeleteMealLocal({
    required this.date,
    required this.mealTime,
    required this.mealId,
  });
}

final class GetDailyMeals extends MealTrackEvent {
  final DateTime date;
  GetDailyMeals({required this.date});
}

final class GetNutrientInfo extends MealTrackEvent {
  GetNutrientInfo();
}
