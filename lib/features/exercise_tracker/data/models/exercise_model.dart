import 'package:fitness_app/core/entities/exercise_entity.dart';

class ExerciseModel {
  final String title;
  final String value;
  final String image;

  ExerciseModel({
    required this.title,
    required this.value,
    required this.image,
  });

  factory ExerciseModel.fromJson(Map<String, dynamic> json) {
    return ExerciseModel(
      title: json['title'],
      value: json['value'],
      image: json['image'],
    );
  }

  ExerciseEntity toEntity() {
    return ExerciseEntity(
    
      name: title,
      value: value,
      image: image,
    );
  }
}
