part of 'sleep_tracker_bloc.dart';

@immutable
sealed class SleepTrackerEvent {}

class UpdateSleepTrackerEvent extends SleepTrackerEvent {
  final DateTime startTime;
  final DateTime endTime;
  UpdateSleepTrackerEvent({required this.startTime, required this.endTime});
}

class GetSleepTrackerEvent extends SleepTrackerEvent {}
