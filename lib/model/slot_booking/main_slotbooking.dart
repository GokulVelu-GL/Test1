import 'package:flutter/material.dart';

class SlotBookingList extends ChangeNotifier {
  static List<Slotdata> slotData = [
    Slotdata(
        id: 1,
        datetime: "2022-04-06 09:30",
        area: "blue building",
        status: "Available",
        zone: "A1 block",
        time: "9:00-9:30",
        filter: "09:30",
        isSelected: false),
    Slotdata(
        id: 2,
        datetime: "2022-04-06 10:00",
        area: "blue building",
        status: "Available",
        zone: "A1 block",
        time: "9:00-9:30",
        filter: "10:00",
        isSelected: false),
    Slotdata(
        id: 3,
        datetime: "2022-04-06 10:30",
        area: "blue building",
        status: "Available",
        zone: "A1 block",
        time: "9:00-9:30",
        filter: "10:30",
        isSelected: false),
    Slotdata(
        id: 4,
        datetime: "2022-04-06 11:00",
        area: "blue building",
        status: "Available",
        zone: "A1 block",
        time: "9:00-9:30",
        filter: "11:00",
        isSelected: false),
    Slotdata(
        id: 5,
        datetime: "2022-04-06 11:30",
        area: "blue building",
        status: "Booked",
        zone: "A1 block",
        time: "9:00-9:30",
        filter: "11:30",
        isSelected: false),
    Slotdata(
        id: 6,
        datetime: "2022-04-06 12:00",
        area: "blue building",
        status: "Available",
        zone: "A1 block",
        time: "9:00-9:30",
        filter: "09:30",
        isSelected: false),
    Slotdata(
        id: 7,
        datetime: "2022-04-06 12:30",
        area: "blue building",
        status: "Available",
        zone: "A1 block",
        time: "9:00-9:30",
        filter: "09:30",
        isSelected: false),
    Slotdata(
        id: 8,
        datetime: "2022-04-06 13:00",
        area: "blue building",
        status: "Available",
        zone: "A1 block",
        time: "9:00-9:30",
        filter: "09:30",
        isSelected: false),
    Slotdata(
        id: 9,
        datetime: "2022-04-06 13:30",
        area: "blue building",
        status: "Available",
        zone: "A1 block",
        time: "9:00-9:30",
        filter: "09:30",
        isSelected: false),
  ];
}

class Slotdata {
  String filter;
  String driverinfo;
  int id;
  String datetime;
  String zone;
  String area;
  String time;
  String status;
  bool isSelected;
  Slotdata({
    this.id,
    @required this.datetime,
    @required this.zone,
    @required this.area,
    @required this.time,
    @required this.status,
    @required this.isSelected,
    @required this.filter,
    @required this.driverinfo,
  });
}
