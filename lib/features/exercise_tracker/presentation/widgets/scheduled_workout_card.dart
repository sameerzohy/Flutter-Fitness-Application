// lib/features/exercise_tracker/presentation/widgets/scheduled_workout_card.dart
import 'package:fitness_app/core/theme/appPalatte.dart'; // Ensure this path is correct
import 'package:fitness_app/features/exercise_tracker/domain/entities/scheduled_workout.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ScheduledWorkoutCard extends StatelessWidget {
  final ScheduledWorkout workout;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const ScheduledWorkoutCard({
    super.key,
    required this.workout,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // Use Container for the gradient background
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0), // More rounded corners
        gradient: const LinearGradient(
          // Gradient background for the card
          colors: [AppPallete.gradient1, AppPallete.gradient2],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          // Subtle shadow for depth
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        // Use Material for InkWell effects
        color:
            Colors
                .transparent, // Make Material transparent to show Container's gradient
        borderRadius: BorderRadius.circular(16.0),
        child: InkWell(
          // Add InkWell for a ripple effect on tap
          borderRadius: BorderRadius.circular(16.0),
          onTap: () {
            // Optional: Define a default tap action if needed, or rely on buttons
          },
          child: Padding(
            padding: const EdgeInsets.all(20.0), // Slightly more padding
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        workout.title,
                        style: const TextStyle(
                          fontSize: 22, // Slightly larger title
                          fontWeight: FontWeight.bold,
                          color: AppPallete.black, // Black text for contrast
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    PopupMenuButton<String>(
                      color: AppPallete.whiteColor, // Popup menu background
                      icon: const Icon(
                        Icons.more_vert,
                        color: AppPallete.black,
                      ), // Black icon
                      onSelected: (value) {
                        if (value == 'edit') {
                          onEdit();
                        } else if (value == 'delete') {
                          onDelete();
                        }
                      },
                      itemBuilder:
                          (BuildContext context) => <PopupMenuEntry<String>>[
                            const PopupMenuItem<String>(
                              value: 'edit',
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.edit,
                                    color: AppPallete.gradient2,
                                  ), // Use gradient color for icon
                                  SizedBox(width: 8),
                                  Text(
                                    'Edit',
                                    style: TextStyle(color: AppPallete.black),
                                  ), // Black text
                                ],
                              ),
                            ),
                            const PopupMenuItem<String>(
                              value: 'delete',
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.delete,
                                    color: AppPallete.errorColor,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    'Delete',
                                    style: TextStyle(color: AppPallete.black),
                                  ), // Black text
                                ],
                              ),
                            ),
                          ],
                    ),
                  ],
                ),
                const SizedBox(height: 10), // Slightly more spacing
                Text(
                  DateFormat(
                    'EEEE, MMM d, yyyy - hh:mm a',
                  ).format(workout.dateTime),
                  style: TextStyle(
                    fontSize: 15, // Slightly larger date/time
                    color: AppPallete.black.withOpacity(
                      0.8,
                    ), // Slightly transparent black
                  ),
                ),
                const SizedBox(height: 15), // More spacing
                const Text(
                  'Exercises:',
                  style: TextStyle(
                    fontSize: 17, // Slightly larger
                    fontWeight: FontWeight.w600,
                    color: AppPallete.black, // Black text
                  ),
                ),
                const SizedBox(height: 10), // More spacing
                Wrap(
                  spacing: 10.0, // Increased spacing between chips
                  runSpacing: 10.0,
                  children:
                      workout.exercises.map((exercise) {
                        return Chip(
                          avatar: ClipRRect(
                            borderRadius: BorderRadius.circular(
                              6,
                            ), // Slightly more rounded avatar
                            child: Image.asset(
                              exercise.image,
                              width: 28, // Slightly larger avatar
                              height: 28,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(
                                  Icons.fitness_center,
                                  size: 28,
                                  color: AppPallete.gradient2,
                                );
                              },
                            ),
                          ),
                          label: Text(
                            '${exercise.name} (${exercise.reps ?? 'N/A'})',
                            style: const TextStyle(
                              color: AppPallete.black,
                            ), // Black text on chips
                          ),
                          backgroundColor: AppPallete.whiteColor.withOpacity(
                            0.8,
                          ), // White chip background for contrast
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              10,
                            ), // More rounded chips
                            side: BorderSide.none,
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ), // More padding on chips
                        );
                      }).toList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
