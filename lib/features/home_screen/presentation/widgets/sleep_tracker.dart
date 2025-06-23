import 'package:fitness_app/features/home_screen/presentation/bloc/sleep_tracker_bloc/sleep_tracker_bloc.dart';
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

  @override
  void initState() {
    super.initState();
    context.read<SleepTrackerBloc>().add(GetSleepTrackerEvent());
  }

  // Picker with custom allowed dates
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
        SnackBar(content: Text("End time must be after start time")),
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
    DateTime? sleepStartTime;
    DateTime? sleepEndTime;
    double sleepTime = 0;
    return BlocBuilder<SleepTrackerBloc, SleepTrackerState>(
      builder: (context, state) {
        if (state is GetSleepTrackerSuccess) {
          sleepStartTime = state.startTime;
          sleepEndTime = state.endTime;
          sleepTime = state.sleepHours;
        }
        return Column(
          children: [
            Image.asset(
              'assets/images/wake-up-icon.png',
              height: 150,
              width: 150,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 10),
            Text(
              'Sleep Start: ${formatDateTime(sleepStartTime)}',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 5),
            Text(
              'Sleep End: ${formatDateTime(sleepEndTime)}',
              style: TextStyle(fontSize: 16),
            ),
            Text('Sleep Duration: $sleepTime'),
            const SizedBox(height: 10),
            ElevatedButton(onPressed: updateSleep, child: Text("Update Sleep")),
          ],
        );
      },
    );
  }
}
