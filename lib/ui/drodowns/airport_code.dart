import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:rooster/string.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AirportCode {
  final String airportCode;
  final String airportName;
  const AirportCode({
    this.airportCode,
    this.airportName,
  });

  static AirportCode fromJson(Map<String, dynamic> json) => AirportCode(
        airportName: json['airportname'],
        airportCode: json['iataairportcode'],
      );
}

// class AirportApi {
//   static Future<List<AirportCode>> getAirportCode(String query) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     final url = Uri.parse(
//         'https://roostertech6.herokuapp.com/api/reference/AirportCode');
//     final response = await http.get(
//       url,
//       headers: <String, String>{
//         'x-access-tokens': prefs.getString('token'),
//         'Content-Type': 'application/json; charset=UTF-8',
//       },
//     );
//     if (response.statusCode == 200) {
//       var result = json.decode(response.body);
//       print(result['records']);
//       final List airportCodes = result['records'];
//       return airportCodes
//           .map((json) => AirportCode.fromJson(json))
//           .where((element) {
//         final airCode = element.airportName.toLowerCase();
//         final queryLower = query.toLowerCase();
//         return airCode.contains(queryLower);
//       }).toList();
//     }
//   }
// }
class AirportApi {
  static Future<List<AirportCode>> getAirportCode(String query) async {
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

    //String airportCode = await rootBundle.loadString('assets/airportCode.json');
    //var result = json.decode(airportCode);

    final List airportCodes = StringData.airportCodes;
    //final List airportCodes = result;
    print(airportCodes);
    return airportCodes
        .map((json) => AirportCode.fromJson(json))
        .where((element) {
      String airCode = element.airportName.toLowerCase();
      final queryLower = query.toLowerCase();
      if (airCode.contains(queryLower)) {
        return airCode.contains(queryLower);
      } else {
        airCode = element.airportCode.toLowerCase();
        return airCode.contains(queryLower);
      }
    }).toList();
    // }
  }
}

class ContactType {
  final String contactCode;
  final String contactType;
  const ContactType({
    this.contactCode,
    this.contactType,
  });

  static ContactType fromJson(Map<String, dynamic> json) => ContactType(
        contactCode: json['contactCode_2char'],
        contactType: json['Contact_Description'],
      );
}

class ContacTypeApi {
  static Future<List<ContactType>> getContactType(String query) async {
    final List contactType = StringData.contactType;
    //final List airportCodes = result;
    print(contactType);
    return contactType
        .map((json) => ContactType.fromJson(json))
        .where((element) {
      String contact = element.contactType.toLowerCase();
      final queryLower = query.toLowerCase();
      if (contact.contains(queryLower)) {
        return contact.contains(queryLower);
      } else {
        contact = element.contactCode.toLowerCase();
        return contact.contains(queryLower);
      }
    }).toList();
    // }
  }
}

class SpecialHandlingGroup {
  final String shgCode;
  final String shgName;
  const SpecialHandlingGroup({
    this.shgCode,
    this.shgName,
  });

  static SpecialHandlingGroup fromJson(Map<String, dynamic> json) =>
      SpecialHandlingGroup(
        shgName: json['Group_SPH_Name'],
        shgCode: json['Group_SPH_Code'],
      );
}

class SpecialHandlingGroupApi {
  static Future<List<SpecialHandlingGroup>> getSpecialHandlingCode(
      String query) async {
    final List shgCodes = StringData.specialhandlinggroup;
    //final List airportCodes = result;
    print(shgCodes);
    return shgCodes
        .map((json) => SpecialHandlingGroup.fromJson(json))
        .where((element) {
      String shgCode = element.shgName.toLowerCase();
      final queryLower = query.toLowerCase();
      if (shgCode.contains(queryLower)) {
        return shgCode.contains(queryLower);
      } else {
        shgCode = element.shgCode.toLowerCase();
        return shgCode.contains(queryLower);
      }
    }).toList();
    // }
  }
}

class CurrencyCode {
  final String currencyCode;
  final String currencyName;

  const CurrencyCode({
    this.currencyCode,
    this.currencyName,
  });

  static CurrencyCode fromJson(Map<String, dynamic> json) => CurrencyCode(
        currencyCode: json['currency_code'],
        currencyName: json['currency_description'],
      );
}

class CurrencyAPI {
  static Future<List<CurrencyCode>> getCurrencyCode(String query) async {
    final List currencyCode = StringData.currencyCode;
    //final List airportCodes = result;
    print(currencyCode);
    return currencyCode
        .map((json) => CurrencyCode.fromJson(json))
        .where((element) {
      String shgCode = element.currencyCode.toLowerCase();
      final queryLower = query.toLowerCase();
      if (shgCode.contains(queryLower)) {
        return shgCode.contains(queryLower);
      } else {
        shgCode = element.currencyName.toLowerCase();
        return shgCode.contains(queryLower);
      }
    }).toList();
    // }
  }

}

class CHGC {
  final String abbrcode;
  final String meaning;

  const CHGC({
    this.abbrcode,
    this.meaning,
  });

  static CHGC fromJson(Map<String, dynamic> json) => CHGC(
    abbrcode: json['Abbr_Code'],
    meaning: json['Meaning'],
  );
}

class CHGSCApi {
  static Future<List<CHGC>> getCHGSType(String query) async {
    final List chgsype = StringData.CHGSCode;
    //final List airportCodes = result;
    print(chgsype);
    return chgsype
        .map((json) => CHGC.fromJson(json))
        .where((element) {
      String contact = element.abbrcode.toLowerCase();
      final queryLower = query.toLowerCase();
      if (contact.contains(queryLower)) {
        return contact.contains(queryLower);
      } else {
        contact = element.meaning.toLowerCase();
        return contact.contains(queryLower);
      }
    }).toList();
    // }
  }
}

class Volume {
  final String abbrcode;
  final String meaning;

  const Volume({
    this.abbrcode,
    this.meaning,
  });

  static Volume fromJson(Map<String, dynamic> json) => Volume(
    abbrcode: json['Abbr_Code'],
    meaning: json['Meaning'],
  );
}

class VolumeCodeApi {
  static Future<List<Volume>> getVolumeCode(String query) async {
    final List volumeCode = StringData.voulmeCodes;
    //final List airportCodes = result;
    print(volumeCode);
    return volumeCode
        .map((json) => Volume.fromJson(json))
        .where((element) {
      String contact = element.abbrcode.toLowerCase();
      final queryLower = query.toLowerCase();
      if (contact.contains(queryLower)) {
        return contact.contains(queryLower);
      } else {
        contact = element.meaning.toLowerCase();
        return contact.contains(queryLower);
      }
    }).toList();
    // }
  }
}
