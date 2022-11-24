class FHLShipperModel {
  String shipperName = '';
  String shipperAddress = '';
  String shipperPlace = '';
  String shipperState = '';
  String shipperCode = '';
  String shipperPostCode = '';
  String shipperIdentifier = '';
  String shipperNumber = '';
  List<Map<String, dynamic>> sippercontactList = [];
  List<ShipperExpenseList> newshipperContactList = [];

  clearShipper() {
    shipperName = '';
    shipperAddress = '';
    shipperPlace = '';
    shipperState = '';
    shipperCode = '';
    shipperPostCode = '';
    shipperIdentifier = '';
    shipperNumber = '';
    sippercontactList = [];
  }
}

// class ShipperContect {
//   bool isSelected = false;
//   String Shipper_Contact_Type;
//   String Shipper_Contact_Detail;

//   ShipperContect(
//       {this.Shipper_Contact_Detail = "",
//       this.Shipper_Contact_Type = "",
//       this.isSelected = false});
//   ShipperContect.fromJson(Map<String, dynamic> json)
//       : Shipper_Contact_Type = json['Shipper_Contact_Type'],
//         Shipper_Contact_Detail = json['Shipper_Contact_Detail'];

// }

class ShipperExpenseList {
  String Shipper_Contact_Type;
  String Shipper_Contact_Detail;
  String flag;
  ShipperExpenseList({
    this.Shipper_Contact_Type,
    this.Shipper_Contact_Detail,
    this.flag
  });
  Map<String, dynamic> toJson() {
    return {
      'Shipper_Contact_Type': Shipper_Contact_Type,
      'Shipper_Contact_Detail': Shipper_Contact_Detail
    };
  }
}
