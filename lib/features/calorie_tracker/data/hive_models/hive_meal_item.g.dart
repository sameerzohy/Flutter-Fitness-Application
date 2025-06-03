// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_meal_item.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HiveMealItemAdapter extends TypeAdapter<HiveMealItem> {
  @override
  final int typeId = 2;

  @override
  HiveMealItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HiveMealItem(
      id: fields[0] as String,
      foodName: fields[1] as String,
      calories: fields[2] as double,
      protein: fields[3] as double,
      carbs: fields[4] as double,
      fat: fields[5] as double,
      fibre: fields[6] as double,
      sugar: fields[7] as double,
      quantity: fields[8] as double,
      unit: fields[9] as String,
      notes: fields[10] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, HiveMealItem obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.foodName)
      ..writeByte(2)
      ..write(obj.calories)
      ..writeByte(3)
      ..write(obj.protein)
      ..writeByte(4)
      ..write(obj.carbs)
      ..writeByte(5)
      ..write(obj.fat)
      ..writeByte(6)
      ..write(obj.fibre)
      ..writeByte(7)
      ..write(obj.sugar)
      ..writeByte(8)
      ..write(obj.quantity)
      ..writeByte(9)
      ..write(obj.unit)
      ..writeByte(10)
      ..write(obj.notes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HiveMealItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
