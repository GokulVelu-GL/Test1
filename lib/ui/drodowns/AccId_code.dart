import '../../string.dart';
class AccId {
  final String abbrcode;
  final String meaning;

  const AccId({
    this.abbrcode,
    this.meaning,
  });

  static AccId fromJson(Map<String, dynamic> json) => AccId(
    abbrcode: json['AccountingInformation_AbbrCode'],
    meaning: json['AccountingInformation_Meaning'],
  );
}

class AccIdCodeApi {
  static Future<List<AccId>> getAccIdCode(String query) async {
    final List volumeCode = StringData.AccountIdCode;
    //final List airportCodes = result;
    print(volumeCode);
    return volumeCode
        .map((json) => AccId.fromJson(json))
        .where((element) {
      String Acc = element.abbrcode.toLowerCase();
      final queryLower = query.toLowerCase();
      if (Acc.contains(queryLower)) {
        return Acc.contains(queryLower);
      } else {
        Acc = element.meaning.toLowerCase();
        return Acc.contains(queryLower);
      }
    }).toList();
    // }
  }
}