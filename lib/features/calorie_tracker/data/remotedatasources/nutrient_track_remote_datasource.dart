import 'package:fitness_app/core/error/exception.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class NutrientTrackRemoteDataSource {
  Future<Map<DateTime, Map<String, dynamic>>> fetchMealDataForWeek();
}

List<DateTime> getDatesInRange(DateTime start, DateTime end) {
  List<DateTime> dates = [];
  for (
    int i = 0;
    start.add(Duration(days: i)).isBefore(end) ||
        start.add(Duration(days: i)).isAtSameMomentAs(end);
    i++
  ) {
    dates.add(start.add(Duration(days: i)));
  }
  return dates;
}

DateTime getFourWeekEndDate() {
  final today = DateTime.now();
  return DateTime(
    today.year,
    today.month,
    today.day,
  ).add(Duration(days: 7 - today.weekday)); // End of current week (Sunday)
}

DateTime getFourWeekStartDate() {
  final endDate = getFourWeekEndDate();
  return endDate.subtract(const Duration(days: 27)); // Start of 4 weeks
}

class NutrientTrackRemoteDataSourceImpl
    implements NutrientTrackRemoteDataSource {
  final SupabaseClient supabaseClient;
  NutrientTrackRemoteDataSourceImpl(this.supabaseClient);

  @override
  Future<Map<DateTime, Map<String, dynamic>>> fetchMealDataForWeek() async {
    try {
      final userId = supabaseClient.auth.currentUser?.id;
      if (userId == null) return {};

      final response = await supabaseClient
          .from('meal_nutrition_tracker')
          .select()
          .eq('user_id', userId)
          .gte('date', getFourWeekStartDate().toIso8601String())
          .lte('date', getFourWeekEndDate().toIso8601String());

      final List<Map<String, dynamic>> data = List<Map<String, dynamic>>.from(
        response,
      );

      // Fill missing dates
      List<DateTime> allDates = getDatesInRange(
        getFourWeekStartDate(),
        getFourWeekEndDate(),
      );
      Map<DateTime, Map<String, dynamic>> finalMap = {
        for (var date in allDates) date: {},
      };
      for (final item in data) {
        DateTime date = DateTime.parse(item['date']);
        finalMap[date] = item;
      }

      return finalMap;
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}
