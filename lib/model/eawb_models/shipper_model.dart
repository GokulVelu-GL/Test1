class ShipperModel {
  // ! 1 - Shipper....
  String shipperAccountNumber = "";
  String shipperName = "";
  String shipperAddress = "";
  String shipperPlace = "";
  String shipperState = "";
  String shipperCountryCode = "";
  String shipperPostCode = "";
  String shipperContactType = "";
  String shipperContactNumber = "";
  int shipperStatus = 0;
  List<ShipperExpenseList> newshipperContactList = List<ShipperExpenseList>();



  void clearShipperModel() {
    shipperAccountNumber = "";
    shipperName = "";
    shipperAddress = "";
    shipperPlace = "";
    shipperState = "";
    shipperCountryCode = "";
    shipperPostCode = "";
    shipperContactType = "";
    shipperContactNumber = "";
    newshipperContactList.clear();
    shipperStatus = 0;
  }

  void setStatusShipperModel() {
    if (shipperAccountNumber == "" &&
        shipperName == "" &&
        shipperAddress == "" &&
        shipperPlace == "" &&
        shipperState == "" &&
        shipperCountryCode == "" &&
        shipperPostCode == "") {
      shipperStatus = 0;
    }
    else if (
    // shipperAccountNumber != "" &&
        shipperName != "" &&
        shipperCountryCode != ""
    ) {
      shipperStatus = 1;
    }else if (shipperAccountNumber == "" ||
        shipperName == "" ||
        shipperAddress == "" ||
        shipperPlace == "" ||
        shipperState == "" ||
        shipperCountryCode == "" ||
        shipperPostCode == "") {
      shipperStatus = -1;
    }
    else {
      shipperStatus = 1;
    }
  }
}

class ShipperExpenseList {
  String Shipper_Contact_Type;
  String Shipper_Contact_Detail;
  String flag;
  ShipperExpenseList({
    this.Shipper_Contact_Type,
    this.Shipper_Contact_Detail,
    this.flag,
  });
  Map<String, dynamic> toJson() {
    return {
      'Shipper_Contact_Type': Shipper_Contact_Type,
      'Shipper_Contact_Detail': Shipper_Contact_Detail
    };
  }
}



