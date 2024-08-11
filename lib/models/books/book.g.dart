// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'book.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BookAdapter extends TypeAdapter<Book> {
  @override
  final int typeId = 0;

  @override
  Book read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Book(
      bookId: fields[0] as String,
      title: fields[1] as String,
      description: fields[2] as String,
      categories: (fields[4] as List?)?.cast<Category>(),
      coverImgPath: fields[3] as String?,
      author: fields[5] as Author?,
      bookDetails: fields[6] as BookDetails?,
      detailsHash: fields[7] as String?,
      coverImgLocalPath: fields[8] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Book obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.bookId)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.coverImgPath)
      ..writeByte(4)
      ..write(obj.categories)
      ..writeByte(5)
      ..write(obj.author)
      ..writeByte(6)
      ..write(obj.bookDetails)
      ..writeByte(7)
      ..write(obj.detailsHash)
      ..writeByte(8)
      ..write(obj.coverImgLocalPath);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BookAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
