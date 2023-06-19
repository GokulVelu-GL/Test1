

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../../screenroute.dart';
import '../../../string.dart';
import '../main_hawb.dart';
import 'model_class.dart';


class Api with ChangeNotifier{

  Future<dynamic> insertAWBList(BuildContext context,String airline, String masterAWB, String shipment, String origin, String destination, String pieces, String weight, String weightUnit, bool offlinestatus) async {
    var result;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var response = await http.post(Uri.parse(StringData.awblistAPI),
        headers: <String, String>{
          'x-access-tokens': prefs.getString('token'),
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          "prefix": airline,
          "wayBillNumber": masterAWB,
          "origin": origin,
          "destination": destination,
          "shipmentcode": shipment,
          "pieces": pieces,
          "weightcode": weightUnit,
          "weight": weight,
          "FlightList_id": 1,
        }
        ));
    result = json.decode(response.body);
    if (result['message'] == 'token expired') {
      refreshToken();
      insertAWBList(context,airline, masterAWB,shipment,origin,destination,pieces,weight,weightUnit,offlinestatus );
      final value = AwbListOffline(
        airline: airline,
        pieces: pieces,
        weight: weight,
      );

      Hive.box('AwbList').add(value);
      Fluttertoast.showToast(
          msg: 'AWB Number Added',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white
      );
    } else {
      result = json.decode(response.body);
      print(prefs.getString('token'));
      print("@@@@@@@@@@@@@@@@@");
      if (response.statusCode == 201) {
        print("insert...................."+result);
        // insertAWB();
        Fluttertoast.showToast(
            msg: 'AWB Number Added',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white
        );
        // final value = AwbListOffline(
        //   airline: airline,
        //   pieces: pieces,
        //   weight: weight,
        // );
        //
        // Hive.box('AwbList').add(value);
        // Scaffold.of(context).showSnackBar(
        //   SnackBar(
        //     content: Text("AWB Number Added"),
        //     duration: Duration(seconds: 1),
        //   ),
        // );
        // _showMessage(
        //     S.of(context).AWBNumberAdded
        //     //"AWB Number Added"
        //     ,
        //     Colors.green,
        //     Colors.white);
        // Navigator.push(context, HomeScreenRoute(MyEawb()));
        //   Navigator.of(context).push(MyEawb());
        print("Data inserted");
      } else {
        // Fluttertoast.showToast(
        //     msg: 'AWB Number Added Failed',
        //     toastLength: Toast.LENGTH_SHORT,
        //     gravity: ToastGravity.BOTTOM,
        //     timeInSecForIosWeb: 1,
        //     backgroundColor: Colors.red,
        //     textColor: Colors.white
        // );
        // Navigator.push(context, HomeScreenRoute(MyEawb()));
        print("Failed");
        // Scaffold.of(context).showSnackBar(
        //   SnackBar(
        //     content: Text("AWB Number Added Failed"),
        //     duration: Duration(seconds: 1),
        //   ),
        // );
        // _showMessage(
        //     S.of(context).AWBNumberAddedFailed
        //     //"AWB Number Added Failed"
        //     ,
        //     Colors.red,
        //     Colors.white);
        print("Data insertion failed");
      }
    }
    return result;
  }
}