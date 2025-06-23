import 'package:fitness_app/core/usecases/usecase.dart';
import 'package:fitness_app/features/home_screen/domain/usecases/other_track_usecase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'other_tracker_event.dart';
part 'other_tracker_state.dart';

class OtherTrackerBloc extends Bloc<OtherTrackerEvent, OtherTrackerState> {
  final UpdateWaterTrackerUsecase _updateWaterTrackerUsecase;
  final GetWaterTrackerUsecase _getWaterTrackerUsecase;

  OtherTrackerBloc({
    required UpdateWaterTrackerUsecase updateWaterTrackerUsecase,
    required GetWaterTrackerUsecase getWaterTrackerUsecase,
  }) : _updateWaterTrackerUsecase = updateWaterTrackerUsecase,
       _getWaterTrackerUsecase = getWaterTrackerUsecase,

       super(OtherTrackerInitial()) {
    on<OtherTrackerEvent>((event, emit) {});
    on<UpdateWaterTrackerEvent>(_onUpdateWaterTracker);
    on<GetWaterTrackerEvent>(_onGetWaterTracker);
  }

  void _onGetWaterTracker(
    GetWaterTrackerEvent event,
    Emitter<OtherTrackerState> emit,
  ) async {
    final res = await _getWaterTrackerUsecase(NoParams());
    res.fold((l) => emit(GetWaterTrackerFailure()), (r) {
      emit(GetWaterTrackerSuccess(r));
    });
  }

  void _onUpdateWaterTracker(
    UpdateWaterTrackerEvent event,
    Emitter<OtherTrackerState> emit,
  ) async {
    final res = await _updateWaterTrackerUsecase(
      WaterTrackerParams(isIncrement: event.increment),
    );
    res.fold((l) => emit(WaterTrackerUpdateFailure()), (r) {
      emit(WaterTrackerUpdatedSuccessfully());
      add(GetWaterTrackerEvent());
    });
  }
}
