import 'package:fitness_app/core/usecases/usecase.dart';
import 'package:fitness_app/features/home_screen/domain/usecases/other_track_usecase.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'sleep_tracker_event.dart';
part 'sleep_tracker_state.dart';

class SleepTrackerBloc extends Bloc<SleepTrackerEvent, SleepTrackerState> {
  final UpdateSleepUsecase _updateSleepUsecase;
  final GetSleepTrackerUsecase _getSleepTrackerUsecase;
  SleepTrackerBloc({
    required UpdateSleepUsecase updateSleepUsecase,
    required GetSleepTrackerUsecase getSleepTrackerUsecase,
  }) : _updateSleepUsecase = updateSleepUsecase,
       _getSleepTrackerUsecase = getSleepTrackerUsecase,
       super(SleepTrackerInitial()) {
    on<UpdateSleepTrackerEvent>(_updateSleepTracker);
    on<GetSleepTrackerEvent>(_onGetSleepTracker);
  }

  void _updateSleepTracker(
    UpdateSleepTrackerEvent event,
    Emitter<SleepTrackerState> emit,
  ) async {
    final res = await _updateSleepUsecase(
      UpdateSleepParams(startTime: event.startTime, endTime: event.endTime),
    );
    res.fold((l) => emit(SleepTrackerUpdateFailure()), (r) {
      emit(SleepTrackerUpdatedSuccessfully());
      add(GetSleepTrackerEvent());
    });
  }

  void _onGetSleepTracker(
    GetSleepTrackerEvent event,
    Emitter<SleepTrackerState> emit,
  ) async {
    final res = await _getSleepTrackerUsecase(NoParams());
    res.fold((l) => emit(GetSleepTrackerFailure()), (r) {
      emit(
        GetSleepTrackerSuccess(
          startTime: r['sleepTimeStart'],
          endTime: r['sleepTimeEnd'],
          sleepHours: r['sleepHours'],
        ),
      );
    });
  }
}
