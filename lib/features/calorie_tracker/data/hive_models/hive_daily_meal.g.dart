// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_daily_meal.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HiveDailyMealAdapter extends TypeAdapter<HiveDailyMeal> {
  @override
  final int typeId = 1;

  @override
  HiveDailyMeal read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HiveDailyMeal(
      date: fields[0] as DateTime,
      mealType: fields[1] as String,
      items: (fields[2] as List).cast<HiveMealItem>(),
    );
  }

  @override
  void write(BinaryWriter writer, HiveDailyMeal obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.date)
      ..writeByte(1)
      ..write(obj.mealType)
      ..writeByte(2)
      ..write(obj.items);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HiveDailyMealAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
