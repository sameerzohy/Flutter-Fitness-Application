part of 'get_remote_tracker_bloc.dart';

@immutable
sealed class GetRemoteTrackerState {}

final class GetRemoteTrackerInitial extends GetRemoteTrackerState {}

final class GetRemoteTrackerSuccess extends GetRemoteTrackerState {
  final List<OtherTracker> otherTracker;
  GetRemoteTrackerSuccess({required this.otherTracker});
}

final class GetRemoteTrackerFailure extends GetRemoteTrackerState {}
