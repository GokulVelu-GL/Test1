
import '../../string.dart';

class RateClassCodeClass {
  final String RateClassCCode;
  final String RateClassName;
  const RateClassCodeClass({
    this.RateClassCCode,
    this.RateClassName,
  });

  static RateClassCodeClass fromJson(Map<String, dynamic> json) => RateClassCodeClass(
    RateClassName: json['Rate_Class_Code_Description'],
    RateClassCCode: json['Rate_Class_Code'],
  );
}
class RateClassCodeApi {
  static Future<List<RateClassCodeClass>> getRateClassCode(String query) async {
    final List contactType = StringData.RateClassCodes;
    //final List airportCodes = result;
    print(contactType);
    return contactType
        .map((json) => RateClassCodeClass.fromJson(json))
        .where((element) {
      String rate = element.RateClassName.toLowerCase();
      final queryLower = query.toLowerCase();
      if (rate.contains(queryLower)) {
        return rate.contains(queryLower);
      } else {
        rate = element.RateClassCCode.toLowerCase();
        return rate.contains(queryLower);
      }
    }).toList();
    // }
  }
}