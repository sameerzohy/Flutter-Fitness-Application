import 'package:fitness_app/features/home_screen/data/hive_models/other_tracker_hive.dart';
import 'package:hive/hive.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> pushOtherTrackerToSupabase(
  Box<OtherTrackerHive> otherTrackerBox,
  SupabaseClient supabaseClient,
) async {
  final today = DateTime.now();
  final dateOnlyToday = DateTime(today.year, today.month, today.day);
  final userId = supabaseClient.auth.currentUser?.id;
  if (userId == null) return;

  final List<String> keysToDelete = [];

  for (final entry in otherTrackerBox.toMap().entries) {
    final key = entry.key;
    final tracker = entry.value;

    final trackerDate = DateTime(
      tracker.date.year,
      tracker.date.month,
      tracker.date.day,
    );

    // Skip today's entry
    if (trackerDate == dateOnlyToday) continue;

    final Map<String, dynamic> row = {
      'user_id': userId,
      'date': trackerDate.toIso8601String().substring(0, 10),
      'water_intake': tracker.waterIntake,
      'sleep_hours': tracker.sleepHours,
      'steps': tracker.steps,
      'sleep_time_start': tracker.sleepTimeStart?.toIso8601String(),
      'sleep_time_end': tracker.sleepTimeEnd?.toIso8601String(),
    };

    try {
      await supabaseClient
          .from('other_tracker')
          .upsert(row, onConflict: 'user_id, date');

      keysToDelete.add(key.toString());
    } catch (e) {
      print('❌ Failed to push other tracker for $key: $e');
    }
  }

  // Delete uploaded entries from Hive
  if (keysToDelete.isNotEmpty) {
    await otherTrackerBox.deleteAll(keysToDelete);
    print(
      '🧹 Deleted ${keysToDelete.length} old other_tracker entries from Hive',
    );
  }
}
