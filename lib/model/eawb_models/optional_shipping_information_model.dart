class OptionalShippingInformationModel {
  // ! 8 - Optional Shipping Information....
  String refNo1 = "";
  String refNo2 = "";
  int optionalShippingInformationStatus = 0;

  void clearOptionalShippingInformationModel() {
    this.refNo1 = this.refNo2;
    this.optionalShippingInformationStatus = 0;
  }

  void setStatusOptionalShippingInformationModel() {
    if (refNo1 == "" && refNo2 == "") {
      optionalShippingInformationStatus = 0;
    }
    else if (refNo1 != "" || refNo2 != "") {
      optionalShippingInformationStatus = 2;

    }
    else if (refNo1 == "" || refNo2 == "") {
      optionalShippingInformationStatus = -1;

    }
   else {
      optionalShippingInformationStatus = 1;
    }
  }
}
