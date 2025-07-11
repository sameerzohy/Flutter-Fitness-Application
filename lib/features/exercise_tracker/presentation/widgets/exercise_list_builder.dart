import 'dart:convert';
import 'package:fitness_app/features/exercise_tracker/presentation/pages/WorkoutDetailPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fitness_app/features/exercise_tracker/data/models/exercise_model.dart';
import 'package:fitness_app/features/exercise_tracker/presentation/widgets/exercise_tile.dart';

class ExerciseListBuilder extends StatelessWidget {
  final String jsonPath;
  final String category;

  const ExerciseListBuilder({
    super.key,
    required this.jsonPath,
    required this.category,
  });

  Future<List<ExerciseModel>> _loadExercises() async {
    final String data = await rootBundle.loadString(jsonPath);
    final Map<String, dynamic> jsonResult = json.decode(data);

    if (!jsonResult.containsKey(category)) {
      throw Exception('Category "$category" not found');
    }

    final List<dynamic> exercisesJson = jsonResult[category];
    return exercisesJson.map((e) => ExerciseModel.fromJson(e)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ExerciseModel>>(
      future: _loadExercises(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("No exercises found"));
        }

        final exercises = snapshot.data!;
        return ListView.builder(
          itemCount: exercises.length,
          itemBuilder: (context, index) {
            final exerciseEntity = exercises[index].toEntity();
            return ExerciseTile(
              data: exerciseEntity,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => WorkoutDetailPage(exercise: exerciseEntity),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
