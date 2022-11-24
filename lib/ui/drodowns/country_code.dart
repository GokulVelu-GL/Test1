import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CountryCode {
  final String countryCode;
  final String countryName;
  const CountryCode({
    this.countryCode,
    this.countryName,
  });

  static CountryCode fromJson(Map<String, dynamic> json) => CountryCode(
        countryName: json['name'],
        countryCode: json['code'],
      );
}

class CountryCodeApi {
  static Future<List<CountryCode>> getCountryCode(String query) async {
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
    // if (response.statusCode == 200) {
    String countryCode = await rootBundle.loadString('assets/countrycode.json');
    var result = json.decode(countryCode);
    print(result);
    final List countryCodeList = result;
    return countryCodeList
        .map((json) => CountryCode.fromJson(json))
        .where((element) {
      String country = element.countryName.toLowerCase();
      final queryLower = query.toLowerCase();
      if (country.contains(queryLower)) {
        return country.contains(queryLower);
      } else {
        country = element.countryCode.toLowerCase();
        return country.contains(queryLower);
      }
    }).toList();
  }
  // }

  static Future<bool> checkifCountryCode(String cCode) async {
    String countryCode = await rootBundle.loadString('assets/countrycode.json');
    var result = json.decode(countryCode);
    print(result);
    final List countryCodeList = result;

    countryCodeList.map((json) => CountryCode.fromJson(json)).where((element) {
      String country = element.countryCode.toLowerCase();

      if (country == cCode) {
        return true;
      } else {
        return false;
      }
    });
  }
}
