import 'package:hive/hive.dart';

part 'model_class.g.dart';

@HiveType(typeId: 0)
class AwbListOffline{
  @HiveField(0)
  String airline;
  @HiveField(1)
  String masterAWB;
  @HiveField(2)
  String origin;
  @HiveField(3)
  String destination;
  @HiveField(4)
  String shipment;
  @HiveField(5)
  String pieces;
  @HiveField(6)
  String weight;
  @HiveField(7)
  String weightUnit;
  AwbListOffline({
     this.airline,
     this.masterAWB,
     this.origin,
     this.destination,
     this.shipment,
     this.pieces,
     this.weight,
     this.weightUnit,
  });
}