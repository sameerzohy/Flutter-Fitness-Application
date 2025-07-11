import 'package:fitness_app/core/usecases/usecase.dart';
import 'package:fitness_app/features/home_screen/data/models/other_tracker_model.dart';
import 'package:fitness_app/features/home_screen/domain/usecases/get_other_tracker_usecase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'get_remote_tracker_event.dart';
part 'get_remote_tracker_state.dart';

class GetRemoteTrackerBloc
    extends Bloc<GetRemoteTrackerEvent, GetRemoteTrackerState> {
  final GetOtherTrackerUsecase _getOtherTrackerUsecase;
  GetRemoteTrackerBloc(this._getOtherTrackerUsecase)
    : super(GetRemoteTrackerInitial()) {
    on<GetRemoteTrackerEvent>((event, emit) {});
    on<GetRemoteTrackerEventDetails>(onGetRemoteTracker);
  }

  void onGetRemoteTracker(
    GetRemoteTrackerEvent event,
    Emitter<GetRemoteTrackerState> emit,
  ) async {
    final res = await _getOtherTrackerUsecase(NoParams());

    res.fold((l) => emit(GetRemoteTrackerFailure()), (r) {
      emit(GetRemoteTrackerSuccess(otherTracker: r));
    });
  }
}
