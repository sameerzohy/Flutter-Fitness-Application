import 'package:fitness_app/core/theme/appPalatte.dart';
import 'package:fitness_app/features/home_screen/presentation/bloc/date_selector_cubit.dart';
import 'package:fitness_app/features/home_screen/presentation/bloc/get_remote_tracker/get_remote_tracker_bloc.dart';
import 'package:fitness_app/features/home_screen/presentation/bloc/other_tracker_bloc/other_tracker_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WaterTracker extends StatefulWidget {
  const WaterTracker({super.key});

  @override
  State<WaterTracker> createState() => _WaterTrackerState();
}

class _WaterTrackerState extends State<WaterTracker> {
  DateTime? _lastDate;
  double waterIntake = 0;

  bool isSameDate(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final selectedDate = context.watch<DateSelectorCubit>().state;

    final int daysDiff = DateTime.now().difference(selectedDate).inDays;
    final int index = 30 - daysDiff - 1;

    if (_lastDate != selectedDate) {
      _lastDate = selectedDate;

      if (isSameDate(selectedDate, DateTime.now())) {
        // Today: fetch/update locally
        context.read<OtherTrackerBloc>().add(GetWaterTrackerEvent());
      } else {
        // Historical: fetch remote if needed
        final remoteState = context.read<GetRemoteTrackerBloc>().state;
        if (remoteState is! GetRemoteTrackerSuccess) {
          context.read<GetRemoteTrackerBloc>().add(
            GetRemoteTrackerEventDetails(),
          );
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
    context.read<OtherTrackerBloc>().add(GetWaterTrackerEvent());
    context.read<GetRemoteTrackerBloc>().add(GetRemoteTrackerEventDetails());
  }

  @override
  Widget build(BuildContext context) {
    final selectedDate = context.watch<DateSelectorCubit>().state;
    final isToday = isSameDate(selectedDate, DateTime.now());

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Image.asset(
              height: 100,
              width: 100,
              'assets/images/glass_with_water.png',
            ),
          ),
          const SizedBox(height: 10),

          // ✅ Buttons for today only
          if (isToday)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _circleButton(
                  icon: Icons.remove,
                  onPressed: () {
                    context.read<OtherTrackerBloc>().add(
                      UpdateWaterTrackerEvent(increment: false),
                    );
                  },
                ),
                const Text('1 Glass: 200ml', style: TextStyle(fontSize: 18)),
                _circleButton(
                  icon: Icons.add,
                  onPressed: () {
                    context.read<OtherTrackerBloc>().add(
                      UpdateWaterTrackerEvent(increment: true),
                    );
                  },
                ),
              ],
            ),

          const SizedBox(height: 10),

          // ✅ Water intake display (based on today or past)
          isToday
              ? BlocBuilder<OtherTrackerBloc, OtherTrackerState>(
                builder: (context, state) {
                  if (state is GetWaterTrackerSuccess) {
                    return Text(
                      'Total Water: ${state.waterTracker} ml',
                      style: const TextStyle(fontSize: 18),
                    );
                  }
                  return const Text(
                    'Loading...',
                    style: TextStyle(fontSize: 18),
                  );
                },
              )
              : BlocBuilder<GetRemoteTrackerBloc, GetRemoteTrackerState>(
                builder: (context, state) {
                  if (state is GetRemoteTrackerSuccess) {
                    final int daysDiff =
                        DateTime.now().difference(selectedDate).inDays;
                    final int index = 30 - daysDiff - 1;

                    if (index >= 0 && index < state.otherTracker.length) {
                      final water = state.otherTracker[index].waterTracker;
                      return Text(
                        'Total Water: $water ml',
                        style: const TextStyle(fontSize: 18),
                      );
                    } else {
                      return const Text('No data available');
                    }
                  }
                  return const Text(
                    'Loading...',
                    style: TextStyle(fontSize: 18),
                  );
                },
              ),
        ],
      ),
    );
  }

  Widget _circleButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppPallete.greenLinear1, AppPallete.greenLinear1],
        ),
        borderRadius: BorderRadius.circular(40),
        border: Border.all(color: Colors.black),
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.black, size: 28),
        onPressed: onPressed,
      ),
    );
  }
}
