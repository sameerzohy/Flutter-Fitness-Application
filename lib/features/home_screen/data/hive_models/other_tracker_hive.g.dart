// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'other_tracker_hive.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class OtherTrackerHiveAdapter extends TypeAdapter<OtherTrackerHive> {
  @override
  final int typeId = 3;

  @override
  OtherTrackerHive read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return OtherTrackerHive(
      date: fields[0] as DateTime,
      sleepHours: fields[1] as double,
      steps: fields[2] as int,
      waterIntake: fields[3] as double,
      sleepTimeStart: fields[4] as DateTime?,
      sleepTimeEnd: fields[5] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, OtherTrackerHive obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.date)
      ..writeByte(1)
      ..write(obj.sleepHours)
      ..writeByte(2)
      ..write(obj.steps)
      ..writeByte(3)
      ..write(obj.waterIntake)
      ..writeByte(4)
      ..write(obj.sleepTimeStart)
      ..writeByte(5)
      ..write(obj.sleepTimeEnd);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OtherTrackerHiveAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
