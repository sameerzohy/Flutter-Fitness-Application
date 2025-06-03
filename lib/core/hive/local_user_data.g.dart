// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_user_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LocalUserDataAdapter extends TypeAdapter<LocalUserData> {
  @override
  final int typeId = 0;

  @override
  LocalUserData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LocalUserData(
      height: fields[0] as double,
      weight: fields[1] as double,
      goalCalories: fields[2] as double,
      goalProtein: fields[3] as double,
      goalCarbs: fields[4] as double,
      goalFat: fields[5] as double,
    );
  }

  @override
  void write(BinaryWriter writer, LocalUserData obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.height)
      ..writeByte(1)
      ..write(obj.weight)
      ..writeByte(2)
      ..write(obj.goalCalories)
      ..writeByte(3)
      ..write(obj.goalProtein)
      ..writeByte(4)
      ..write(obj.goalCarbs)
      ..writeByte(5)
      ..write(obj.goalFat);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LocalUserDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
