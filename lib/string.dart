// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
//
// import 'model/airport_model.dart';
//
// class StringData {
//   static final String loginAPI = 'https://roostertech6.herokuapp.com/api/login';
//
//   static final String registerAPI =
//       'https://roostertech6.herokuapp.com/api/register';
//
//   static final String forgotPasswordAPI =
//       'https://roostertech6.herokuapp.com/api/forgot-password';
//
//   static final String emailConfirmationAPI =
//       'https://roostertech6.herokuapp.com/api/resend-email-confirmation';
//
//   static final String refreshTokenAPI =
//       'https://roostertech6.herokuapp.com/api/refresh-token';
//
//   static final String getEAWBAPI =
//       'https://roostertech6.herokuapp.com/api/eawb/awbdetails';
//
//   static final String saveEAWBAPI =
//       'https://roostertech6.herokuapp.com/api/savepdf';
//
//   static final String printEAWBAPI =
//       'https://roostertech6.herokuapp.com/api/printpdf';
//
//   static String fileEAWBAPI(fileName) =>
//       'https://roostertech6.herokuapp.com$fileName';
//   static final String flightlistAPI =
//       'https://roostertech6.herokuapp.com/api/eawb/flightlist';
//
//   static final String airportAPI =
//       'http://www.json-generator.com/api/json/get/bQKOycURFe?indent=2';
//
//   static final String awblistAPI =
//       'https://roostertech6.herokuapp.com/api/eawb/awblist';
//
//   static String awblistDeleteAPI(id) =>
//       'https://roostertech6.herokuapp.com/api/eawb/awblist$id';
//
//   static final String insertListawb =
//       'https://roostertech6.herokuapp.com/api/insert/awblist';
//
//   static final String insertawbAPI =
//       'https://roostertech6.herokuapp.com/api/Eawb/insert';
//
//   static final String deleteawbAPI =
//       'https://roostertech6.herokuapp.com/api/deleteAwb/';
//
//   static final String eawbbyid =
//       'https://roostertech6.herokuapp.com/api/eawb/awbdetails';
//
//   // FhL APIs
//
//   static final String inserthawbAPI =
//       'https://roostertech6.herokuapp.com/api/eawb/housedetails';
//
//   static String hawblistAPI =
//       'https://roostertech6.herokuapp.com/api/eawb/housedetails';
//
//   static String hawbbyid(String hawbid) =>
//       'https://roostertech6.herokuapp.com/api/hawbbyid/$hawbid';
//
//   static String updateFHL = 'https://roostertech6.herokuapp.com/updateHouse';
//   static String getAwbid =
//       'https://roostertech6.herokuapp.com/api/eawb/awblist';
//
//
//   // Profile APIs
//
//   static String profileupload =
//       "https://roostertech6.herokuapp.com/api/profileupload";
//
//   //ToDo list API
//
//   static String todoListAPI =
//       "https://roostertech6.herokuapp.com/api/eawb/todolist";
//
//   static final String manifestPdfAPI =
//       "https://roostertech6.herokuapp.com/api/manifestgeneratepdf";
//
//   static final String bankExchangeRate =
//        "https://roostertech6.herokuapp.com/api/reference/BankExchangeRate";
//
//   static String manifestAPI =
//       "https://roostertech6.herokuapp.com/api/eawb/ffmawbdetails";
// // charge declaration page chgs code charge code
//   static String ChargeDeclarationCHGSCode =
//    "https://roostertech6.herokuapp.com/api/reference/CHGS_Code";
//   static List<dynamic> CHGSCode;
//
//   //volume unit in AWB Consignment Details Page
//   static String voulmeunit =
//   "https://roostertech6.herokuapp.com/api/reference/VolumeCodes";
//   static List<dynamic> voulmeCodes;
//   static String ratedescriptionRateClass =
//   "https://roostertech6.herokuapp.com/api/reference/RateClass";
//   static String accountingInformationIdentifier =
//       "https://roostertech6.herokuapp.com/api/reference/AccountingInformation_Identifiers";
//   // rate description Rate Class
//
//   static List<dynamic> AccountIdCode;
//
//
//   static List<dynamic> RateClassCodes;
//   static Future loadRateClassCode() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     final url = Uri.parse(
//         'https://roostertech6.herokuapp.com/api/reference/RateClass');
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
//       RateClassCodes = result['records'];
//       return RateClassCodes;
//     } else {
//       var result = json.decode(response.body);
//       print("RateClass Code Not found");
//       print(result);
//       return "data not found";
//     }
//   }
//
//   static Future loadAccId() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     final url = Uri.parse(
//         'https://roostertech6.herokuapp.com/api/reference/AccountingInformation_Identifiers');
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
//       AccountIdCode = result['records'];
//       return AccountIdCode;
//     } else {
//       var result = json.decode(response.body);
//       print("AccId Code Not found");
//       print(result);
//       return "data not found";
//     }
//   }
//   static List<dynamic> airportCodes;
//
//   static List<dynamic> airlineCodes;
//
//   static List<dynamic> contactType;
//   static List<dynamic> specialhandlinggroup;
//   static List<dynamic> currencyCode;
//   static List<dynamic> exchangerate;
//
//
//   static Future loadAirportCode() async {
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
//       airportCodes = result['records'];
//       return airportCodes;
//     } else {
//       var result = json.decode(response.body);
//       print("Airport Code Not found");
//       print(result);
//       return "data not found";
//     }
//   }
//   static Future loadAirlineCode() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     final url = Uri.parse(
//         'https://roostertech6.herokuapp.com/api/reference/AirlineCode');
//     final response = await http.get(
//       url,
//       headers: <String, String>{
//         'x-access-tokens': prefs.getString('token'),
//         'Content-Type': 'application/json; charset=UTF-8',
//       },
//     );
//     if (response.statusCode == 200) {
//       var result = json.decode(response.body);
//       print("Airlinessssssssssss");
//       print(result['records']);
//       airlineCodes = result['records'];
//       return airlineCodes;
//
//     } else {
//       var result = json.decode(response.body);
//       print("Airport Code Not found");
//       print(result);
//       return "data not found";
//     }
//   }
//   static Future loadVolumeCode() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     final url = Uri.parse(
//         'https://roostertech6.herokuapp.com/api/reference/VolumeCodes');
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
//       voulmeCodes = result['records'];
//       return voulmeCodes;
//     } else {
//       return "data not found";
//     }
//   }
//
//   static Future loadtContactType() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     final url = Uri.parse(
//         'https://roostertech6.herokuapp.com/api/reference/ContactType');
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
//       contactType = result['records'];
//       return contactType;
//     } else {
//       return "data not found";
//     }
//   }
//   static Future loadtCHGSCode() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     final url = Uri.parse(
//         'https://roostertech6.herokuapp.com/api/reference/CHGS_Code');
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
//       CHGSCode = result['records'];
//       return CHGSCode;
//     } else {
//       return "data not found";
//     }
//   }
//
//   static Future<void> sendMessage(String text) async {
//     FlutterLocalNotificationsPlugin notifications =
//         FlutterLocalNotificationsPlugin();
//     var androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
//     var iOSInit = IOSInitializationSettings();
//     var init = InitializationSettings(android: androidInit, iOS: iOSInit);
//     notifications.initialize(init).then((done) {
//       notifications.show(
//           0,
//           "ToDo Notification",
//           text,
//           const NotificationDetails(
//               android: AndroidNotificationDetails(
//                   "announcement_app_0", "Announcement App", ""),
//               iOS: IOSNotificationDetails()));
//     });
//   }
//
//   static Future loadShgCode() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     final url = Uri.parse(
//         'https://roostertech6.herokuapp.com/api/reference/GroupSpecialHandling');
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
//       specialhandlinggroup = result['records'];
//       return specialhandlinggroup;
//     } else {
//       return "data not found";
//     }
//   }
//
//   static Future loadCurrency() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     final url =
//         Uri.parse('https://roostertech6.herokuapp.com//api/reference/Currency');
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
//       currencyCode = result['records'];
//       return currencyCode;
//     } else {
//       return "data not found";
//     }
//   }
//
//   static Future loadExchangeRate() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     final url = Uri.parse(bankExchangeRate);
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
//       exchangerate = result['records'];
//       // prefs.setStringList("exrate", List<String>.from(exchangerate));
//       return exchangerate;
//     } else {
//       return "data not found";
//     }
//   }
//
//   static String getCurrencyrate(String from, String to) {
//     // ignore: missing_return
//     String rate = null;
//     exchangerate
//         //.map((json) => CurrencyRateCode.fromJson(json))
//         .forEach((element) {
//       print('$element  $from  $to');
//
//       if (element['base_currency'].toString() == from &&
//           element['desired_currency'].toString() == to) {
//         print(element['base_currency']);
//         print(element['exchange_rate']);
//         rate = element['exchange_rate'].toString();
//       }
//     });
//     return rate;
//   }
//
//   static  Future<List<AirportModel>> loadAirport() async {
//     List<AirportModel> _airportsList = new List<AirportModel>();
//     try {
//       final response = await http
//           .get("https://roostertech6.herokuapp.com/api/reference/AirportCode");
//       if (response.statusCode == 200) {
//         final parsed =
//         json.decode(response.body)["airports"].cast<Map<String, dynamic>>();
//         _airportsList = parsed
//             .map<AirportModel>((json) => AirportModel.fromJson(json))
//             .toList();
//         print(_airportsList);
//         return _airportsList;
//       } else {
//         print("Error in Airport API eawb_nav_page");
//         return null;
//       }
//     } catch (e) {
//       print("Error in occur API");
//       print(e);
//       return null;
//     }
//   }
// }
//
// class CurrencyRateCode {
//   final String baseCurrency;
//   final String currencyDest;
//   final int exchangeRate;
//
//   const CurrencyRateCode(
//       {this.baseCurrency, this.currencyDest, this.exchangeRate});
//
//   static CurrencyRateCode fromJson(Map<String, dynamic> json) =>
//       CurrencyRateCode(
//         baseCurrency: json['base_currency'],
//         currencyDest: json['currency_description'],
//         exchangeRate: json['exchange_rate'],
//       );
// }
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'model/airport_model.dart';

class StringData {

  static final String loginAPI = 'https://ec2-44-204-173-113.compute-1.amazonaws.com:8008/api/login';

  static final String registerAPI =
      'https://ec2-44-204-173-113.compute-1.amazonaws.com:8008/api/register';

  static final String forgotPasswordAPI =
      'https://ec2-44-204-173-113.compute-1.amazonaws.com:8008/api/forgot-password';

  static final String emailConfirmationAPI =
      'https://ec2-44-204-173-113.compute-1.amazonaws.com:8008/api/resend-email-confirmation';

  static final String refreshTokenAPI =
      'https://ec2-44-204-173-113.compute-1.amazonaws.com:8008/api/refresh-token';

  static final String getEAWBAPI =
      'https://ec2-44-204-173-113.compute-1.amazonaws.com:8008/api/eawb/awbdetails';

  static final String saveEAWBAPI =
      'https://ec2-44-204-173-113.compute-1.amazonaws.com:8008/api/savepdf';

  static final String printEAWBAPI =
      'https://ec2-44-204-173-113.compute-1.amazonaws.com:8008/api/printpdf';

  static String fileEAWBAPI(fileName) =>
      'https://roostertech6.herokuapp.com$fileName';
  static final String flightlistAPI =
      'https://ec2-44-204-173-113.compute-1.amazonaws.com:8008/api/eawb/flightlist';

  static final String airportAPI =
      'https://www.json-generator.com/api/json/get/bQKOycURFe?indent=2';

  static final String awblistAPI =
      'https://ec2-44-204-173-113.compute-1.amazonaws.com:8008/api/eawb/awblist';

  static String awblistDeleteAPI(id) =>
      'https://ec2-44-204-173-113.compute-1.amazonaws.com:8008/api/eawb/awblist$id';

  static final String insertListawb =
      'https://ec2-44-204-173-113.compute-1.amazonaws.com:8008/api/insert/awblist';

  static final String insertawbAPI =
      'https://ec2-44-204-173-113.compute-1.amazonaws.com:8008/api/Eawb/insert';

  static final String deleteawbAPI =
      'https://ec2-44-204-173-113.compute-1.amazonaws.com:8008/api/deleteAwb/';

  static final String eawbbyid =
      'https://ec2-44-204-173-113.compute-1.amazonaws.com:8008/api/eawb/awbdetails';

  // FHL APIs

  static final String inserthawbAPI =
      'https://ec2-44-204-173-113.compute-1.amazonaws.com:8008/api/eawb/housedetails';

  static String hawblistAPI =
      'https://ec2-44-204-173-113.compute-1.amazonaws.com:8008/api/eawb/housedetails';

  static String hawbbyid(String hawbid) =>
      'https://ec2-44-204-173-113.compute-1.amazonaws.com:8008/api/hawbbyid/$hawbid';

  static String updateFHL = 'https://ec2-44-204-173-113.compute-1.amazonaws.com:8008/updateHouse';
  static String getAwbid =
      'https://ec2-44-204-173-113.compute-1.amazonaws.com:8008/api/eawb/awblist';


  // Profile APIs

  static String profileupload =
      "https://ec2-44-204-173-113.compute-1.amazonaws.com:8008/api/profileupload";

  //ToDo list API

  static String todoListAPI =
      "https://ec2-44-204-173-113.compute-1.amazonaws.com:8008/api/eawb/todolist";

  static final String manifestPdfAPI =
      "https://ec2-44-204-173-113.compute-1.amazonaws.com:8008/api/manifestgeneratepdf";

  static final String bankExchangeRate =
      "https://ec2-44-204-173-113.compute-1.amazonaws.com:8008/api/reference/BankExchangeRate";

  static String manifestAPI =
      "https://ec2-44-204-173-113.compute-1.amazonaws.com:8008/api/eawb/ffmawbdetails";
// charge declaration page chgs code charge code
  static String ChargeDeclarationCHGSCode =
      "https://ec2-44-204-173-113.compute-1.amazonaws.com:8008/api/reference/CHGS_Code";
  static List<dynamic> CHGSCode;

  //volume unit in AWB Consignment Details Page
  static String voulmeunit =
      "https://ec2-44-204-173-113.compute-1.amazonaws.com:8008/api/reference/VolumeCodes";
  static List<dynamic> voulmeCodes;
  static String ratedescriptionRateClass =
      "https://ec2-44-204-173-113.compute-1.amazonaws.com:8008/api/reference/RateClass";
  static String accountingInformationIdentifier =
      "https://ec2-44-204-173-113.compute-1.amazonaws.com:8008/api/reference/AccountingInformation_Identifiers";
  // rate description Rate Class

  static List<dynamic> AccountIdCode;


  static List<dynamic> RateClassCodes;
  static Future loadRateClassCode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final url = Uri.parse(
        'https://ec2-44-204-173-113.compute-1.amazonaws.com:8008/api/reference/RateClass');
    final response = await http.get(
      url,
      headers: <String, String>{
        'x-access-tokens': prefs.getString('token'),
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    if (response.statusCode == 200) {
      var result = json.decode(response.body);
      print(result['records']);
      RateClassCodes = result['records'];
      return RateClassCodes;
    } else {
      var result = json.decode(response.body);
      print("RateClass Code Not found");
      print(result);
      return "data not found";
    }
  }

  static Future loadAccId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final url = Uri.parse(
        'https://ec2-44-204-173-113.compute-1.amazonaws.com:8008/api/reference/AccountingInformation_Identifiers');
    final response = await http.get(
      url,
      headers: <String, String>{
        'x-access-tokens': prefs.getString('token'),
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    if (response.statusCode == 200) {
      var result = json.decode(response.body);
      print(result['records']);
      AccountIdCode = result['records'];
      return AccountIdCode;
    } else {
      var result = json.decode(response.body);
      print("AccId Code Not found");
      print(result);
      return "data not found";
    }
  }
  static List<dynamic> airportCodes;

  static List<dynamic> airlineCodes;

  static List<dynamic> contactType;
  static List<dynamic> specialhandlinggroup;
  static List<dynamic> currencyCode;
  static List<dynamic> exchangerate;


  static Future loadAirportCode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final url = Uri.parse(
        'https://ec2-44-204-173-113.compute-1.amazonaws.com:8008/api/reference/AirportCode');
    final response = await http.get(
      url,
      headers: <String, String>{
        'x-access-tokens': prefs.getString('token'),
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    if (response.statusCode == 200) {
      var result = json.decode(response.body);
      print(result['records']);
      airportCodes = result['records'];
      return airportCodes;
    } else {
      var result = json.decode(response.body);
      print("Airport Code Not found");
      print(result);
      return "data not found";
    }
  }
  static Future loadAirlineCode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final url = Uri.parse(
        'https://ec2-44-204-173-113.compute-1.amazonaws.com:8008/api/reference/AirlineCode');
    final response = await http.get(
      url,
      headers: <String, String>{
        'x-access-tokens': prefs.getString('token'),
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    if (response.statusCode == 200) {
      var result = json.decode(response.body);
      print("Airlinessssssssssss");
      print(result['records']);
      airlineCodes = result['records'];
      return airlineCodes;

    } else {
      var result = json.decode(response.body);
      print("Airport Code Not found");
      print(result);
      return "data not found";
    }
  }
  static Future loadVolumeCode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final url = Uri.parse(
        'https://ec2-44-204-173-113.compute-1.amazonaws.com:8008/api/reference/VolumeCodes');
    final response = await http.get(
      url,
      headers: <String, String>{
        'x-access-tokens': prefs.getString('token'),
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    if (response.statusCode == 200) {
      var result = json.decode(response.body);
      print(result['records']);
      voulmeCodes = result['records'];
      return voulmeCodes;
    } else {
      return "data not found";
    }
  }

  static Future loadtContactType() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final url = Uri.parse(
        'https://ec2-44-204-173-113.compute-1.amazonaws.com:8008/api/reference/ContactType');
    final response = await http.get(
      url,
      headers: <String, String>{
        'x-access-tokens': prefs.getString('token'),
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    if (response.statusCode == 200) {
      var result = json.decode(response.body);
      print(result['records']);
      contactType = result['records'];
      return contactType;
    } else {
      return "data not found";
    }
  }
  static Future loadtCHGSCode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final url = Uri.parse(
        'https://ec2-44-204-173-113.compute-1.amazonaws.com:8008/api/reference/CHGS_Code');
    final response = await http.get(
      url,
      headers: <String, String>{
        'x-access-tokens': prefs.getString('token'),
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    if (response.statusCode == 200) {
      var result = json.decode(response.body);
      print(result['records']);
      CHGSCode = result['records'];
      return CHGSCode;
    } else {
      return "data not found";
    }
  }

  static Future<void> sendMessage(String text) async {
    FlutterLocalNotificationsPlugin notifications =
    FlutterLocalNotificationsPlugin();
    var androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    var iOSInit = IOSInitializationSettings();
    var init = InitializationSettings(android: androidInit, iOS: iOSInit);
    notifications.initialize(init).then((done) {
      notifications.show(
          0,
          "ToDo Notification",
          text,
           NotificationDetails(
              android: AndroidNotificationDetails(
                  "announcement_app_0", "Announcement App",""),
              iOS: IOSNotificationDetails()));
    });
  }

  static Future loadShgCode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final url = Uri.parse(
        'https://ec2-44-204-173-113.compute-1.amazonaws.com:8008/api/reference/GroupSpecialHandling');
    final response = await http.get(
      url,
      headers: <String, String>{
        'x-access-tokens': prefs.getString('token'),
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    if (response.statusCode == 200) {
      var result = json.decode(response.body);
      print(result['records']);
      specialhandlinggroup = result['records'];
      return specialhandlinggroup;
    } else {
      return "data not found";
    }
  }

  static Future loadCurrency() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final url =
    Uri.parse('https://ec2-44-204-173-113.compute-1.amazonaws.com:8008//api/reference/Currency');
    final response = await http.get(
      url,
      headers: <String, String>{
        'x-access-tokens': prefs.getString('token'),
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    if (response.statusCode == 200) {
      var result = json.decode(response.body);
      print(result['records']);
      currencyCode = result['records'];
      return currencyCode;
    } else {
      return "data not found";
    }
  }

  static Future loadExchangeRate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final url = Uri.parse(bankExchangeRate);
    final response = await http.get(
      url,
      headers: <String, String>{
        'x-access-tokens': prefs.getString('token'),
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    if (response.statusCode == 200) {
      var result = json.decode(response.body);
      print(result['records']);
      exchangerate = result['records'];
      // prefs.setStringList("exrate", List<String>.from(exchangerate));
      return exchangerate;
    } else {
      return "data not found";
    }
  }

  static String getCurrencyrate(String from, String to) {
    // ignore: missing_return
    String rate = null;
    exchangerate
    //.map((json) => CurrencyRateCode.fromJson(json))
        .forEach((element) {
      print('$element  $from  $to');

      if (element['base_currency'].toString() == from &&
          element['desired_currency'].toString() == to) {
        print(element['base_currency']);
        print(element['exchange_rate']);
        rate = element['exchange_rate'].toString();
      }
    });
    return rate;
  }

  static  Future<List<AirportModel>> loadAirport() async {
    List<AirportModel> _airportsList = new List<AirportModel>();
    try {
      final response = await http
          .get(Uri.parse("https://ec2-44-204-173-113.compute-1.amazonaws.com:8008/api/reference/AirportCode"));
      if (response.statusCode == 200) {
        final parsed =
        json.decode(response.body)["airports"].cast<Map<String, dynamic>>();
        _airportsList = parsed
            .map<AirportModel>((json) => AirportModel.fromJson(json))
            .toList();
        print(_airportsList);
        return _airportsList;
      } else {
        print("Error in Airport API eawb_nav_page");
        return null;
      }
    } catch (e) {
      print("Error in occur API");
      print(e);
      return null;
    }
  }
}

class CurrencyRateCode {
  final String baseCurrency;
  final String currencyDest;
  final int exchangeRate;

  const CurrencyRateCode(
      {this.baseCurrency, this.currencyDest, this.exchangeRate});

  static CurrencyRateCode fromJson(Map<String, dynamic> json) =>
      CurrencyRateCode(
        baseCurrency: json['base_currency'],
        currencyDest: json['currency_description'],
        exchangeRate: json['exchange_rate'],
      );
}
