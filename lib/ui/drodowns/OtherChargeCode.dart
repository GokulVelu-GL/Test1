
import '../../string.dart';

class OtherChargesCode {
  final String OtherChargeCode;
  final String OtherChargeName;
  const OtherChargesCode({
    this.OtherChargeCode,
    this.OtherChargeName,
  });

  static OtherChargesCode fromJson(Map<String, dynamic> json) => OtherChargesCode(
    OtherChargeName: json['ChargeCode_Meaning'],
  OtherChargeCode: json['ChargeCode_Abbr'],
  );
}
class OtherChargeCodeClassApi {
  static Future<List<OtherChargesCode>> getRateClassCode(String query) async {
    final List contactType = StringData.OtherChargeCodeList;
    //final List airportCodes = result;
    print(contactType);
    return contactType
        .map((json) => OtherChargesCode.fromJson(json))
        .where((element) {
      String rate = element.OtherChargeName.toLowerCase();
      final queryLower = query.toLowerCase();
      if (rate.contains(queryLower)) {
        return rate.contains(queryLower);
      } else {
        rate = element.OtherChargeCode.toLowerCase();
        return rate.contains(queryLower);
      }
    }).toList();
    // }
  }
}