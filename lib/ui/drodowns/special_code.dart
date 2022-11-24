import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SpecialCode {
  final String codeType;
  final String codeName;
  const SpecialCode({
    this.codeType,
    this.codeName,
  });

  static SpecialCode fromJson(Map<String, dynamic> json) => SpecialCode(
        codeType: json['SPH_Type_Code'],
        codeName: json['SPH_Type_Name'],
      );
}

class SpecialCodeApi {
  static Future<List<SpecialCode>> getSpecialCode(String query) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // final url = Uri.parse(
    //     'https://roostertech6.herokuapp.com/api/reference/SpecialHandlingType');
    // final response = await http.get(
    //   url,
    //   headers: <String, String>{
    //     'x-access-tokens': prefs.getString('token'),
    //     'Content-Type': 'application/json; charset=UTF-8',
    //   },
    // );
    // if (response.statusCode == 200) {
    String specialCode = await rootBundle.loadString('assets/specialcode.json');
    var result = json.decode(specialCode);
    // print(result['records']);
    final List countryCode = result;
    return countryCode
        .map((json) => SpecialCode.fromJson(json))
        .where((element) {
      String specialCode = element.codeType.toLowerCase();
      final queryLower = query.toLowerCase();
      if (specialCode.contains(queryLower)) {
        return specialCode.contains(queryLower);
      } else {
        specialCode = element.codeName.toLowerCase();
        return specialCode.contains(queryLower);
      }
    }).toList();
    // }
  }
}
