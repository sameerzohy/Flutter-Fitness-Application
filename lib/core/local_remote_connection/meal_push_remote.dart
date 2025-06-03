import 'package:fitness_app/features/calorie_tracker/data/hive_models/hive_meal_item.dart';
import 'package:hive/hive.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

String findMealTime(String key) {
  if (key.contains('BreakFast')) return 'breakfast';
  if (key.contains('Lunch')) return 'lunch';
  if (key.contains('Dinner')) return 'dinner';
  if (key.contains('Morning Snack')) return 'morningsnack';
  return 'eveningsnack';
}

Future<void> pushMealToSupabase(
  Box<HiveMealItem> hiveBox,
  SupabaseClient supabaseClient,
) async {
  final today = DateTime.now();
  final dateOnly = DateTime(today.year, today.month, today.day);
  final userId = supabaseClient.auth.currentUser?.id;
  if (userId == null) return;

  final Map<DateTime, Map<String, List<HiveMealItem>>> map = {};
  final Set<String> keysToDelete = {};

  // Step 1: Group meals by date and meal time (excluding today)
  for (final entry in hiveBox.toMap().entries) {
    final key = entry.key;
    final item = entry.value;
    final datePart = key.toString().substring(0, 10);
    final currDate = DateTime.parse(datePart);

    if (currDate == dateOnly) continue;

    final mealTime = findMealTime(key);
    map.putIfAbsent(currDate, () => {});
    map[currDate]!.putIfAbsent(mealTime, () => []);
    map[currDate]![mealTime]!.add(item);
  }

  // Step 2: Upload each grouped date
  for (final entry in map.entries) {
    final date = entry.key;
    final mealsByTime = entry.value;

    final Map<String, dynamic> row = {
      'user_id': userId,
      'date': date.toIso8601String().substring(0, 10),
    };

    // Step 3: Add nutrient data for each meal time
    for (final mealTime in mealsByTime.keys) {
      final items = mealsByTime[mealTime]!;

      final totalCalories = items.fold(0.0, (sum, item) => sum + item.calories);
      final totalCarbs = items.fold(0.0, (sum, item) => sum + item.carbs);
      final totalProtein = items.fold(0.0, (sum, item) => sum + item.protein);
      final totalFat = items.fold(0.0, (sum, item) => sum + item.fat);
      final totalSugar = items.fold(0.0, (sum, item) => sum + item.sugar);
      final totalFiber = items.fold(0.0, (sum, item) => sum + item.fibre);

      row['${mealTime}_calories'] = totalCalories;
      row['${mealTime}_carbs'] = totalCarbs;
      row['${mealTime}_protein'] = totalProtein;
      row['${mealTime}_fat'] = totalFat;
      row['${mealTime}_sugar'] = totalSugar;
      row['${mealTime}_fiber'] = totalFiber;
    }

    // Step 4: Insert into Supabase and handle errors
    try {
      await supabaseClient
          .from('meal_nutrition_tracker')
          .upsert(row, onConflict: 'user_id, date');

      // Mark keys for deletion
      final keysForDate =
          hiveBox.keys
              .where(
                (k) => k.toString().startsWith(
                  date.toIso8601String().substring(0, 10),
                ),
              )
              .toList();
      keysToDelete.addAll(keysForDate.map((e) => e.toString()));
    } catch (e) {
      print('❌ Failed to upload for $date: $e');
    }
  }

  // Step 5: Clean up Hive box
  if (keysToDelete.isNotEmpty) {
    await hiveBox.deleteAll(keysToDelete);
    // print('🧹 Deleted ${keysToDelete.length} old meal entries from Hive');
  }
}
