// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recipe_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RecipeModelAdapter extends TypeAdapter<RecipeModel> {
  @override
  final int typeId = 0;

  @override
  RecipeModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RecipeModel(
      title: fields[0] as String,
      duration: fields[1] as String,
      difficulty: fields[2] as double,
      portions: fields[3] as int,
      portionsUnits: fields[4] as String,
      instructions: (fields[5] as List).cast<String>(),
      ingredientsQuantity: (fields[6] as List).cast<double>(),
      ingredientsUnits: (fields[7] as List).cast<String>(),
      ingredientsNames: (fields[8] as List).cast<String>(),
      imagePath: fields[9] as String?,
      category: fields[10] as String,
    );
  }

  @override
  void write(BinaryWriter writer, RecipeModel obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.duration)
      ..writeByte(2)
      ..write(obj.difficulty)
      ..writeByte(3)
      ..write(obj.portions)
      ..writeByte(4)
      ..write(obj.portionsUnits)
      ..writeByte(5)
      ..write(obj.instructions)
      ..writeByte(6)
      ..write(obj.ingredientsQuantity)
      ..writeByte(7)
      ..write(obj.ingredientsUnits)
      ..writeByte(8)
      ..write(obj.ingredientsNames)
      ..writeByte(9)
      ..write(obj.imagePath)
      ..writeByte(10)
      ..write(obj.category);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RecipeModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
