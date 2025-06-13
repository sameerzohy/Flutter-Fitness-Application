import 'package:fitness_app/core/theme/appPalatte.dart';
import 'package:flutter/material.dart';

import 'package:fitness_app/core/entities/workout.dart';

class WorkoutCard extends StatelessWidget {
  final Workout workout;
  final VoidCallback? onTap;

  const WorkoutCard({Key? key, required this.workout, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(
                workout.isActive ? Icons.fitness_center : Icons.fitness_center_outlined,
                color: workout.isActive ? AppPallete.gradient2 : AppPallete.gray1,
                size: 40,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      workout.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      workout.time,
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              if (workout.isActive)
                const Icon(Icons.check_circle, color: AppPallete.TrackerGreen)
            ],
          ),
        ),
      ),
    );
  }
}
