import 'package:flutter/material.dart';

class SlotBookingList extends ChangeNotifier {
  static List<Slotdata> slotData = [
    Slotdata(
        id: 1,
        datetime: "2022-11-24 09:30",
        area: "blue building",
        status: "Available",
        zone: "A1 block",
        time: "9:00-9:30",
        filter: "09:30",
        isSelected: false, driverinfo: 'NAVEEN'),
    Slotdata(
        id: 2,
        datetime: "2022-11-24 10:00",
        area: "blue building",
        status: "Available",
        zone: "A1 block",
        time: "9:00-9:30",
        filter: "10:00",
        isSelected: false, driverinfo: 'GOKUL'),
    Slotdata(
        id: 3,
        datetime: "2022-11-24 10:30",
        area: "blue building",
        status: "Available",
        zone: "A1 block",
        time: "9:00-9:30",
        filter: "10:30",
        isSelected: false, driverinfo: 'KARTHI'),
    Slotdata(
        id: 4,
        datetime: "2022-11-24 11:00",
        area: "blue building",
        status: "Available",
        zone: "A1 block",
        time: "9:00-9:30",
        filter: "11:00",
        isSelected: false, driverinfo: ''),
    Slotdata(
        id: 5,
        datetime: "2022-11-24 11:30",
        area: "blue building",
        status: "Booked",
        zone: "A1 block",
        time: "9:00-9:30",
        filter: "11:30",
        isSelected: false, driverinfo: ''),
    Slotdata(
        id: 6,
        datetime: "2022-11-24 12:00",
        area: "blue building",
        status: "Available",
        zone: "A1 block",
        time: "9:00-9:30",
        filter: "09:30",
        isSelected: false, driverinfo: ''),
    Slotdata(
        id: 7,
        datetime: "2022-11-24 12:30",
        area: "blue building",
        status: "Available",
        zone: "A1 block",
        time: "9:00-9:30",
        filter: "09:30",
        isSelected: false, driverinfo: ''),
    Slotdata(
        id: 8,
        datetime: "2022-11-24 13:00",
        area: "blue building",
        status: "Available",
        zone: "A1 block",
        time: "9:00-9:30",
        filter: "09:30",
        isSelected: false, driverinfo: ''),
    Slotdata(
        id: 9,
        datetime: "2022-11-24 13:30",
        area: "blue building",
        status: "Available",
        zone: "A1 block",
        time: "9:00-9:30",
        filter: "09:30",
        isSelected: false, driverinfo: ''),
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
