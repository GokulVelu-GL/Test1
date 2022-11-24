class CcChargesInDestinationCurrencyModel {
  // ! 13 - CC charges in destination currency....
  String destCurrencyCode = "";
  String currencyConversionRates = "";
  String baseCurencyrate = "";
  String ccChargesInDest = "";
  String chargesAtDest = "";
  String totalCollect = "";
  int ccChargesInDestinationCurrencyStatus = 0;

  void clearCcChargesInDestinationCurrencyModel() {
    this.destCurrencyCode = this.currencyConversionRates =
        this.ccChargesInDest = this.chargesAtDest = this.totalCollect = '';
    this.ccChargesInDestinationCurrencyStatus = 0;
  }

  void setStatusCcChargesInDestinationCurrencyModel() {
    if (currencyConversionRates == "" &&
        ccChargesInDest == "" &&
        chargesAtDest == "" &&
        totalCollect == "" &&
        destCurrencyCode == "") {
      ccChargesInDestinationCurrencyStatus = 0;
    } else if (currencyConversionRates == "" ||
        ccChargesInDest == "" ||
        chargesAtDest == "" ||
        totalCollect == "" ||
        destCurrencyCode == "") {
      ccChargesInDestinationCurrencyStatus = -1;
    } else {
      ccChargesInDestinationCurrencyStatus = 1;
    }
  }
}
