// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model_class.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AwbListOfflineAdapter extends TypeAdapter<AwbListOffline> {
  @override
  final int typeId = 0;

  @override
  AwbListOffline read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AwbListOffline(
      airline: fields[0] as String,
      masterAWB: fields[1] as String,
      origin: fields[2] as String,
      destination: fields[3] as String,
      shipment: fields[4] as String,
      pieces: fields[5] as String,
      weight: fields[6] as String,
      weightUnit: fields[7] as String,
    );
  }

  @override
  void write(BinaryWriter writer, AwbListOffline obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.airline)
      ..writeByte(1)
      ..write(obj.masterAWB)
      ..writeByte(2)
      ..write(obj.origin)
      ..writeByte(3)
      ..write(obj.destination)
      ..writeByte(4)
      ..write(obj.shipment)
      ..writeByte(5)
      ..write(obj.pieces)
      ..writeByte(6)
      ..write(obj.weight)
      ..writeByte(7)
      ..write(obj.weightUnit);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AwbListOfflineAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
