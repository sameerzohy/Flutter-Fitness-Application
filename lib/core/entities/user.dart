class User {
  final String id;
  final String name;
  final String email;
  final String? goal;
  final String? gender;
  final double? height;
  final double? weight;
  final String? date_of_birth;
  final double? bmi;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.goal,
    this.gender,
    this.height,
    this.weight,
    this.date_of_birth,
    this.bmi,
  });
}
