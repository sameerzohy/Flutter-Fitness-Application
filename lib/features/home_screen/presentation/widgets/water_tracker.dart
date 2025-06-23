import 'package:fitness_app/core/theme/appPalatte.dart';
import 'package:fitness_app/features/home_screen/presentation/bloc/other_tracker_bloc/other_tracker_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WaterTracker extends StatefulWidget {
  const WaterTracker({super.key});

  @override
  State<WaterTracker> createState() => _WaterTrackerState();
}

class _WaterTrackerState extends State<WaterTracker> {
  @override
  void initState() {
    super.initState();
    context.read<OtherTrackerBloc>().add(GetWaterTrackerEvent());
  }

  @override
  Widget build(BuildContext context) {
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppPallete.greenLinear1, AppPallete.greenLinear1],
                  ),
                  borderRadius: BorderRadius.circular(40),
                  border: Border.all(color: Colors.black),
                ),
                child: IconButton(
                  icon: Icon(Icons.add, color: Colors.black, size: 28),
                  onPressed: () {
                    context.read<OtherTrackerBloc>().add(
                      UpdateWaterTrackerEvent(increment: true),
                    );
                  },
                ),
              ),
              Text('1 Glass: 200ml', style: TextStyle(fontSize: 18)),
              Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppPallete.greenLinear1, AppPallete.greenLinear1],
                  ),
                  borderRadius: BorderRadius.circular(40),
                  border: Border.all(color: Colors.black),
                ),
                child: IconButton(
                  icon: Icon(Icons.remove, color: Colors.black, size: 28),
                  onPressed: () {
                    context.read<OtherTrackerBloc>().add(
                      UpdateWaterTrackerEvent(increment: false),
                    );
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          BlocBuilder<OtherTrackerBloc, OtherTrackerState>(
            builder: (context, state) {
              if (state is GetWaterTrackerSuccess) {
                return Text(
                  'Total Water: ${state.waterTracker} ml',
                  style: TextStyle(fontSize: 18),
                );
              }
              return Text('Total Water: 0 ml', style: TextStyle(fontSize: 18));
            },
          ),
        ],
      ),
    );
  }
}

// Navigator.of(context).push(PageRouteBuilder(transitionDuration: 300, transitionBuilder: (context, animation, secondaryAnimations, child) => FadeTransition(opacity: animation, child: child))
