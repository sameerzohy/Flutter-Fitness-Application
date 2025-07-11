import 'package:fitness_app/features/home_screen/presentation/bloc/date_selector_cubit.dart';
import 'package:fitness_app/features/home_screen/presentation/bloc/sleep_tracker_bloc/sleep_tracker_bloc.dart';
import 'package:fitness_app/features/home_screen/presentation/bloc/get_remote_tracker/get_remote_tracker_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SleepTracker extends StatefulWidget {
  const SleepTracker({super.key});

  @override
  State<SleepTracker> createState() => _SleepTrackerState();
}

class _SleepTrackerState extends State<SleepTracker> {
  final DateTime today = DateTime.now();
  late final DateTime yesterday = today.subtract(Duration(days: 1));
  DateTime? _lastDate;

  bool isSameDate(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final selectedDate = context.watch<DateSelectorCubit>().state;

    final remoteState = context.read<GetRemoteTrackerBloc>().state;
    final int daysDiff = DateTime.now().difference(selectedDate).inDays;
    final int index = 30 - daysDiff - 1;

    if (_lastDate != selectedDate) {
      _lastDate = selectedDate;

      if (isSameDate(selectedDate, today)) {
        context.read<SleepTrackerBloc>().add(GetSleepTrackerEvent());
      } else if (remoteState is! GetRemoteTrackerSuccess) {
        context.read<GetRemoteTrackerBloc>().add(
          GetRemoteTrackerEventDetails(),
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    context.read<SleepTrackerBloc>().add(GetSleepTrackerEvent());
    context.read<GetRemoteTrackerBloc>().add(GetRemoteTrackerEventDetails());
  }

  // Utility: Picker for start/end datetime
  Future<DateTime?> pickDateTime({
    required BuildContext context,
    required String label,
    required DateTime initialDate,
    required DateTime firstDate,
    required DateTime lastDate,
  }) async {
    final date = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
      helpText: 'Select $label Date',
    );
    if (date == null) return null;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      helpText: 'Select $label Time',
    );
    if (time == null) return null;

    return DateTime(date.year, date.month, date.day, time.hour, time.minute);
  }

  void updateSleep() async {
    final start = await pickDateTime(
      context: context,
      label: "Sleep Start",
      initialDate: yesterday,
      firstDate: yesterday,
      lastDate: today,
    );
    if (start == null) return;

    final end = await pickDateTime(
      context: context,
      label: "Sleep End",
      initialDate: today,
      firstDate: today,
      lastDate: today,
    );
    if (end == null) return;

    if (end.isBefore(start)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("End time must be after start time")),
      );
      return;
    }

    context.read<SleepTrackerBloc>().add(
      UpdateSleepTrackerEvent(startTime: start, endTime: end),
    );
  }

  String formatDateTime(DateTime? dt) {
    if (dt == null) return "--";
    return "${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')} (${dt.day}/${dt.month})";
  }

  @override
  Widget build(BuildContext context) {
    final selectedDate = context.watch<DateSelectorCubit>().state;
    final isToday = isSameDate(selectedDate, today);

    DateTime? sleepStartTime;
    DateTime? sleepEndTime;
    double sleepTime = 0;

    return Column(
      children: [
        Image.asset(
          'assets/images/wake-up-icon.png',
          height: 150,
          width: 150,
          fit: BoxFit.contain,
        ),
        const SizedBox(height: 10),

        // Today – Use local bloc state
        if (isToday)
          BlocBuilder<SleepTrackerBloc, SleepTrackerState>(
            builder: (context, state) {
              if (state is GetSleepTrackerSuccess) {
                sleepStartTime = state.startTime;
                sleepEndTime = state.endTime;
                sleepTime = state.sleepHours;
              }
              return _sleepDetails(
                sleepStartTime,
                sleepEndTime,
                sleepTime,
                isToday,
              );
            },
          ),

        // Past – Use remote data
        if (!isToday)
          BlocBuilder<GetRemoteTrackerBloc, GetRemoteTrackerState>(
            builder: (context, state) {
              if (state is GetRemoteTrackerSuccess) {
                final daysDiff = DateTime.now().difference(selectedDate).inDays;
                final index = 30 - daysDiff - 1;
                if (index >= 0 && index < state.otherTracker.length) {
                  final tracker = state.otherTracker[index];
                  return _sleepDetails(
                    tracker.sleepStartTime,
                    tracker.sleepEndTime,
                    tracker.sleepTracker,
                    isToday,
                  );
                } else {
                  return const Text("No data available for this date");
                }
              }
              return const Text("Loading...");
            },
          ),

        if (isToday) const SizedBox(height: 10),
        if (isToday)
          ElevatedButton(
            onPressed: updateSleep,
            child: const Text("Update Sleep"),
          ),
      ],
    );
  }

  Widget _sleepDetails(
    DateTime? start,
    DateTime? end,
    double hours,
    bool isToday,
  ) {
    return Column(
      children: [
        Text(
          'Sleep Start: ${formatDateTime(start)}',
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 5),
        Text(
          'Sleep End: ${formatDateTime(end)}',
          style: const TextStyle(fontSize: 16),
        ),
        Text('Sleep Duration: $hours hours'),
      ],
    );
  }
}
