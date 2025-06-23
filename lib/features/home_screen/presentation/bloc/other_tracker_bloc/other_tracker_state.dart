part of 'other_tracker_bloc.dart';

@immutable
sealed class OtherTrackerState {}

final class OtherTrackerInitial extends OtherTrackerState {}

final class WaterTrackerUpdatedSuccessfully extends OtherTrackerState {}

final class WaterTrackerUpdateFailure extends OtherTrackerState {}

final class GetWaterTrackerSuccess extends OtherTrackerState {
  final int waterTracker;
  GetWaterTrackerSuccess(this.waterTracker);
}

final class GetWaterTrackerFailure extends OtherTrackerState {}
