class OtherTracker {
  final double waterTracker;
  final double sleepTracker;
  final double stepsTracker;
  DateTime? sleepStartTime;
  DateTime? sleepEndTime;

  OtherTracker({
    required this.waterTracker,
    required this.sleepTracker,
    required this.stepsTracker,
    this.sleepStartTime,
    this.sleepEndTime,
  });
}
