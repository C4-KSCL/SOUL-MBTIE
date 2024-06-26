// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'oppuser_number.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class OppUserNumberAdapter extends TypeAdapter<OppUserNumber> {
  @override
  final int typeId = 0;

  @override
  OppUserNumber read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return OppUserNumber()..oppUserNumber = fields[0] as String?;
  }

  @override
  void write(BinaryWriter writer, OppUserNumber obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.oppUserNumber);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OppUserNumberAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
