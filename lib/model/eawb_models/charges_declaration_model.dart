class ChargesDeclarationModel {
  // ! 9 - Charges declaration....
  String chargesDeclarationCurrency = "";
  String chargesDeclarationCHGSCode = "";
  String chargesDeclarationValueForCarriage = "";
  String chargesDeclarationValueForCustoms = "";
  String chargesDeclarationWTVALCharges = "PPD";
  String chargesDeclarationOtherCharges = "PPD";
  String chargesDeclarationAmountOfInsurance = "";
  int chargesDeclarationStatus = 0;

  void clearChargesDeclarationModel() {
    this.chargesDeclarationCurrency = this.chargesDeclarationCHGSCode =
        this.chargesDeclarationValueForCarriage =
            this.chargesDeclarationValueForCustoms =
                this.chargesDeclarationAmountOfInsurance = '';
    this.chargesDeclarationOtherCharges =
        this.chargesDeclarationWTVALCharges = 'PPD';

    this.chargesDeclarationStatus = 0;
  }

  void setStatusChargesDeclarationModel() {
    if (chargesDeclarationCurrency == "" &&
        chargesDeclarationCHGSCode == "" &&
        chargesDeclarationValueForCarriage == "" &&
        chargesDeclarationValueForCustoms == "" &&
        chargesDeclarationWTVALCharges == "" &&
        chargesDeclarationOtherCharges == "" &&
        chargesDeclarationAmountOfInsurance == "") {
      chargesDeclarationStatus = 0;
    } else if (chargesDeclarationCurrency == "" ||
        chargesDeclarationCHGSCode == "" ||
        chargesDeclarationValueForCarriage == "" ||
        chargesDeclarationValueForCustoms == "" ||
        chargesDeclarationWTVALCharges == "" ||
        chargesDeclarationOtherCharges == "" ||
        chargesDeclarationAmountOfInsurance == "") {
      chargesDeclarationStatus = -1;
    } else {
      chargesDeclarationStatus = 1;
    }
  }
}
