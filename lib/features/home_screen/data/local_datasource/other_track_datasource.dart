import 'package:fitness_app/core/error/exception.dart';
import 'package:fitness_app/features/home_screen/data/hive_models/other_tracker_hive.dart';
import 'package:hive/hive.dart';

abstract interface class OtherTrackLocalDatasource {
  Future<void> updateWaterTracekr(bool increment);
  Future<void> updateSleepTracker(DateTime startTime, DateTime endTime);
  Future<void> updateStepsTracker(bool increment);
  Future<Map<String, dynamic>> getSleepsTracker();
  Future<int> getStepsTracker();
  Future<int> getWaterTracker();
}

// implementing the OtherTrackLocalDatasource Class

class OtherTrackDatasourceImpl extends OtherTrackLocalDatasource {
  final Box<OtherTrackerHive> hiveBox;
  OtherTrackDatasourceImpl(this.hiveBox);

  String dateKey() {
    final now = DateTime.now();
    return "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
  }

  @override
  Future<void> updateWaterTracekr(bool increment) async {
    try {
      String key =
          dateKey(); // assuming key is the string form of the date or similar
      final tracker = hiveBox.get(key);
      print('tracker intake in update ${tracker!.waterIntake}');

      final updated = OtherTrackerHive(
        date: tracker.date,
        sleepHours: tracker.sleepHours,
        steps: tracker.steps,
        waterIntake: (tracker.waterIntake + (increment ? 200 : -200)).clamp(
          0.0,
          double.infinity,
        ), // assuming 250ml step
      );
      await hiveBox.put(key, updated);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<void> updateSleepTracker(DateTime startTime, DateTime endTime) async {
    try {
      final Duration diff = endTime.difference(startTime);
      final double hours = diff.inMinutes / 60.0;
      print('start time in update ${startTime}');
      print('end time in update ${endTime}');

      String key = dateKey();

      final tracker = hiveBox.get(key);

      if (tracker != null) {
        final updated = OtherTrackerHive(
          date: tracker.date,
          sleepHours: hours,
          steps: tracker.steps,
          waterIntake: tracker.waterIntake,
          sleepTimeStart: startTime,
          sleepTimeEnd: endTime,
        );

        await hiveBox.put(key, updated);
      }
      print('success update of Sleep Tracker');
    } catch (e) {
      print('failure ${e.toString}');
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<void> updateStepsTracker(bool increment) {
    // TODO: implement updateStepsTracker
    throw UnimplementedError();
  }

  @override
  Future<Map<String, dynamic>> getSleepsTracker() async {
    String key = dateKey();
    try {
      final tracker = hiveBox.get(key);
      print('sleepTime start: ${tracker!.sleepTimeStart}');
      print('sleepTime end: ${tracker.sleepTimeEnd}');

      return {
        'sleepTimeStart': tracker.sleepTimeStart,
        'sleepTimeEnd': tracker.sleepTimeEnd,
        'sleepHours': tracker.sleepHours,
      };
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<int> getStepsTracker() async {
    String key = dateKey();
    for (final entry in hiveBox.toMap().entries) {
      if (entry.key == key) {
        final e = entry.value;
        return e.steps;
      }
    }
    return 0;
  }

  @override
  Future<int> getWaterTracker() async {
    try {
      final box = hiveBox.get(dateKey());
      return box!.waterIntake.toInt();
    } catch (e) {
      // print('getting Failure');
      throw ServerException(message: e.toString());
    }
  }
}
