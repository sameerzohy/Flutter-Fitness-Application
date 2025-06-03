import 'package:fitness_app/core/hive/local_user_data.dart';
import 'package:hive/hive.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> initializeUserData(SupabaseClient supabase) async {
  final box = await Hive.openBox<LocalUserData>('userBox');

  final userData = box.get('user');

  final isMissing =
      userData == null ||
      userData.height == 0 ||
      userData.weight == 0 ||
      userData.goalCalories == 0 ||
      userData.goalProtein == 0 ||
      userData.goalCarbs == 0 ||
      userData.goalFat == 0;

  if (isMissing) {
    final userId = supabase.auth.currentUser?.id;

    if (userId != null) {
      final response =
          await supabase
              .from('profiles') // use your actual Supabase table name
              .select()
              .eq('id', userId)
              .single();

      final double height = (response['height'] as num).toDouble(); // cm
      final double weight = (response['weight'] as num).toDouble(); // kg

      final double bmr = 10 * weight + 6.25 * height - 5 * 25 + 5;

      // Apply activity factor (lightly active)
      final double goalCalories = bmr * 1.4;

      // Macronutrient goals based on typical distribution:
      final double goalProtein = weight * 1.8; // grams
      final double goalFat = weight * 0.9; // grams

      // Calories used: 4 cal/g (protein), 9 cal/g (fat)
      final double proteinCalories = goalProtein * 4;
      final double fatCalories = goalFat * 9;

      // Remaining for carbs
      final double remainingCalories =
          goalCalories - proteinCalories - fatCalories;
      final double goalCarbs = remainingCalories / 4;
      final fetched = LocalUserData(
        height: height,
        weight: weight,
        goalCalories: goalCalories,
        goalProtein: goalProtein,
        goalCarbs: goalCarbs,
        goalFat: goalFat,
      );

      await box.put('user', fetched);
    }
  }
}
