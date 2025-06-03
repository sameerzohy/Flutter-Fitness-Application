import 'package:hive/hive.dart';

part 'local_user_data.g.dart';

@HiveType(typeId: 0)
class LocalUserData extends HiveObject {
  @HiveField(0)
  final double height;

  @HiveField(1)
  final double weight;

  @HiveField(2)
  final double goalCalories;

  @HiveField(3)
  final double goalProtein;

  @HiveField(4)
  final double goalCarbs;

  @HiveField(5)
  final double goalFat;

  LocalUserData({
    required this.height,
    required this.weight,
    required this.goalCalories,
    required this.goalProtein,
    required this.goalCarbs,
    required this.goalFat,
  });
}
