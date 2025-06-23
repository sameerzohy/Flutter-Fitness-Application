part of 'sleep_tracker_bloc.dart';

@immutable
sealed class SleepTrackerState {}

final class SleepTrackerInitial extends SleepTrackerState {}

final class GetSleepTrackerSuccess extends SleepTrackerState {
  final DateTime? startTime;
  final DateTime? endTime;
  final double sleepHours;
  GetSleepTrackerSuccess({
    required this.sleepHours,
    this.startTime,
    this.endTime,
  });
}

final class GetSleepTrackerFailure extends SleepTrackerState {}

final class SleepTrackerUpdateFailure extends SleepTrackerState {}

final class SleepTrackerUpdatedSuccessfully extends SleepTrackerState {}
