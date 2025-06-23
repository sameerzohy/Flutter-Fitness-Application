import 'package:hive/hive.dart';

part 'other_tracker_hive.g.dart';

@HiveType(typeId: 3)
class OtherTrackerHive extends HiveObject {
  @HiveField(0)
  DateTime date;

  @HiveField(1)
  double sleepHours;

  @HiveField(2)
  int steps;

  @HiveField(3)
  double waterIntake;

  @HiveField(4)
  DateTime? sleepTimeStart; // new field

  @HiveField(5)
  DateTime? sleepTimeEnd; // new field

  OtherTrackerHive({
    required this.date,
    required this.sleepHours,
    required this.steps,
    required this.waterIntake,
    this.sleepTimeStart,
    this.sleepTimeEnd,
  });
}
