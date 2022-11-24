// http://www.json-generator.com/api/json/get/cqsLxcCzIi?indent=2f;
class AirportModel {
  String airportName;
  String airportCode;
  String airportLocation;
  AirportModel({this.airportName, this.airportCode, this.airportLocation});

  factory AirportModel.fromJson(Map<String, dynamic> parsedJson) {
    return AirportModel(
      airportCode: parsedJson['IATA'] as String,
      airportName: parsedJson['name'] as String,
      airportLocation: parsedJson['location'] as String,
    );
  }
}
