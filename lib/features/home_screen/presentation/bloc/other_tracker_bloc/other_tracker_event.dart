part of 'other_tracker_bloc.dart';

@immutable
sealed class OtherTrackerEvent {}

class UpdateWaterTrackerEvent extends OtherTrackerEvent {
  final bool increment;
  UpdateWaterTrackerEvent({required this.increment});
}

class GetWaterTrackerEvent extends OtherTrackerEvent {}
