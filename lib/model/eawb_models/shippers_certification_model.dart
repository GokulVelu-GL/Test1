class ShippersCertificationModel {
  // ! 15 - Shipper's certification....
  String signatureOfShipper = "";
  String particularsOfShipper = "";
  int shipperCertificationStatus = 0;

  void clearShippersCertificationModel() {
    this.signatureOfShipper = this.particularsOfShipper = '';
    this.shipperCertificationStatus = 0;
  }

  void setStatusShippersCertificationModel() {
    if (signatureOfShipper == "" && particularsOfShipper == "") {
      shipperCertificationStatus = 0;
    } else if (signatureOfShipper == "" || particularsOfShipper == "") {
      shipperCertificationStatus = -1;
    } else {
      shipperCertificationStatus = 1;
    }
  }
}
