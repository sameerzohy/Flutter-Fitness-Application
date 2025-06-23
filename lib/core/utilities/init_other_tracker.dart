import 'package:fitness_app/features/home_screen/data/hive_models/other_tracker_hive.dart';
import 'package:hive/hive.dart';

String dateKey() {
  final now = DateTime.now();
  return "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
}

DateTime parseDate() {
  final now = DateTime.now();
  return DateTime(now.year, now.month, now.day);
}

Future<void> initOtherTracker(Box<OtherTrackerHive> otherTrackerHive) async {
  try {
    final today = dateKey();

    if (!otherTrackerHive.containsKey(today)) {
      otherTrackerHive.put(
        today,
        OtherTrackerHive(
          date: parseDate(),
          waterIntake: 0,
          sleepHours: 0,
          steps: 0,
        ),
      );
    }
  } catch (e) {
    print(e.toString());
  }
}
