// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'readlist_recipe_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ReadRecModelAdapter extends TypeAdapter<ReadRecModel> {
  @override
  final int typeId = 1;

  @override
  ReadRecModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ReadRecModel(
      title: fields[0] as String,
      link: fields[1] as String,
      category: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ReadRecModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.link)
      ..writeByte(2)
      ..write(obj.category);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReadRecModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
