import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../string.dart';

class AirlineCode {
  final String airlineCode;
  final String airlineName;
  final String airlinePrifix;
  const AirlineCode({this.airlineCode, this.airlineName, this.airlinePrifix});

  static AirlineCode fromJson(Map<String, dynamic> json) => AirlineCode(
        airlineCode: json['airline_code'],
        airlineName: json['airline'],
        airlinePrifix: json['mawb_prefix'],
      );
}

// class AirlineCodeApi {
//   static Future<List<AirlineCode>> getAirlineCode(String query) async {
//     // SharedPreferences prefs = await SharedPreferences.getInstance();
//     // final url = Uri.parse(
//     //     'https://roostertech6.herokuapp.com/api/reference/AirlineCode');
//     // final response = await http.get(
//     //   url,
//     //   headers: <String, String>{
//     //     'x-access-tokens': prefs.getString('token'),
//     //     'Content-Type': 'application/json; charset=UTF-8',
//     //   },
//     // );
//     // if (response.statusCode == 200) {
//     //   var result = json.decode(response.body);
//     //   print(result['records']);
//     //   final List airportCodes = result['records'];
//       final List airlineCodes = StringData.airlineCodes;
//       return airlineCodes
//           .map((json) => AirlineCode.fromJson(json))
//           .where((element) {
//         final airCode = element.airlinePrifix.toLowerCase();
//         final queryLower = query.toLowerCase();
//         return airCode.contains(queryLower);
//       }).toList();
//     }
//   }
class AirlineCodeApi {
  static Future<List<AirlineCode>> getAirlineCode(String query) async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // final url = Uri.parse(
    //     'https://roostertech6.herokuapp.com/api/reference/AirportCode');
    // final response = await http.get(
    //   url,
    //   headers: <String, String>{
    //     'x-access-tokens': prefs.getString('token'),
    //     'Content-Type': 'application/json; charset=UTF-8',
    //   },
    // );
    //if (response.statusCode == 200) {

    // String airlineCodes =
    //     await rootBundle.loadString('assets/airlinecode.json');
    // var result = json.decode(airlineCodes);
    // print(result);
    // final List airlineCodesl = result;
    final List airlineCodes = StringData.airlineCodes;
    return airlineCodes
        .map((json) => AirlineCode.fromJson(json))
        .where((element) {
      String airCode = element.airlineCode.toLowerCase();
      final queryLower = query.toLowerCase();
      if (airCode.contains(queryLower)) {
        return airCode.contains(queryLower);
      }
      // if (airCode.contains(queryLower)) {
      //   airCode = element.airlineCode.toLowerCase();
      //   print(airCode);
      //   return airCode.contains(queryLower);
      // }
      else {
        airCode = element.airlinePrifix.toString().toLowerCase();
        return airCode.contains(queryLower);
      }
      // } else{
      //   airCode = element.airlinePrifix.toString().toLowerCase();
      //   print(airCode);
      //   return airCode.contains(queryLower);
      // }
      // } else {
      //   airCode = element.airlinePrifix;
      //   return airCode.contains(queryLower);
      // }
    }).toList();
    // }
  }
}
