// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'author.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AuthorAdapter extends TypeAdapter<Author> {
  @override
  final int typeId = 2;

  @override
  Author read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Author(
      name: fields[0] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Author obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.name);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AuthorAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
