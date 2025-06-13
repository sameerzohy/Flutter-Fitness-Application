class ExerciseEntity {
  final String? id;
  final String name;
  final String? value; // Add this if you're referring to 'value'
  final String image;

  ExerciseEntity({
    this.id,
    required this.name,
    this.value,
    required this.image,
  });
}
