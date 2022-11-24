class FHLQuantityDetailsModel {
  String quantityDetailsPieces = '';
  String quantityDetailsWeight = '';
  String quantityDetailsWeightUnit = "K";
  String quantityDetailsSLAC = '';

  clearQuantityDetails() {
    quantityDetailsPieces = "";
    quantityDetailsWeight = "";
    quantityDetailsWeightUnit = "";
    quantityDetailsSLAC = "";
  }
}
