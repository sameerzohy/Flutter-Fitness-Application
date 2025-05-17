import 'package:fitness_app/core/entities/user.dart';

class UserModel extends User {
  UserModel({
    required super.id,
    required super.name,
    required super.email,
    super.goal,
    super.gender,
    super.height,
    super.weight,
    super.date_of_birth,
    super.bmi,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      goal: json['goal'],
      gender: json['gender'],
      height: json['height'],
      weight: json['weight'],
      date_of_birth: json['date_of_birth'],
      bmi: json['bmi'],
    );
  }

  UserModel copyWith({String? id, String? name, String? email}) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
    );
  }
}
