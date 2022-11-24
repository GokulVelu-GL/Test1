import 'dart:convert';

Welcome welcomeFromJson(String str) => Welcome.fromJson(json.decode(str));

String welcomeToJson(Welcome data) => json.encode(data.toJson());

class Welcome {
  Welcome({
    this.awb,
  });

  List<Awb> awb;

  factory Welcome.fromJson(Map<String, dynamic> json) => Welcome(
        awb: List<Awb>.from(json["awb"].map((x) => Awb.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "awb": List<dynamic>.from(awb.map((x) => x.toJson())),
      };
}

class Awb {
  Awb({
    this.id,
    this.prefix,
    this.wayBillNumber,
  });

  int id;
  int prefix;
  String wayBillNumber;

  factory Awb.fromJson(Map<String, dynamic> json) => Awb(
        id: json["id"],
        prefix: json["prefix"],
        wayBillNumber: json["wayBillNumber"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "prefix": prefix,
        "wayBillNumber": wayBillNumber,
      };
}
