import 'package:flutter/material.dart';
import 'package:fitness_app/core/theme/appPalatte.dart';
import 'package:fitness_app/features/exercise_tracker/presentation/widgets/exercise_list_builder.dart';

class AbWorkoutPage extends StatelessWidget {
  final String title;
  final String imagePath;
  final String category;

  const AbWorkoutPage({
    super.key,
    required this.title,
    required this.imagePath,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.only(top: 18, left: 8),
          child: IconButton(
            iconSize: 30,
            icon: const Icon(Icons.chevron_left_rounded, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        title: Padding(
          padding: const EdgeInsets.only(top: 18),
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppPallete.trackerContainerBackground1,
                AppPallete.trackerContainerBackground2,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          // Top Image Section
          Container(
            height: 300,
            width: double.infinity,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppPallete.trackerContainerBackground1,
                  AppPallete.trackerContainerBackground2,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
            ),
            child: Container(
              height: 180,
              width: 180,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 12,
                    offset: Offset(0, 6),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(16),
              child: Image.asset(imagePath, fit: BoxFit.contain),
            ),
          ),

          const SizedBox(height: 16),

          // Exercise list using reusable widget
          Expanded(
            child: ExerciseListBuilder(
              jsonPath: 'assets/data/workouts.json',
              category: category,
            ),
          ),
        ],
      ),
    );
  }
}
