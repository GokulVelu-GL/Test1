class IssuerModel {
  // ! 6 - Issuer....
  String issuerBy = "";
  int issuerStatus = 0;

  void clearIssuerModel() {
    this.issuerBy = '';
    this.issuerStatus = 0;
  }

  void setStatusIssuerModel() {
    if (issuerBy == "") {
      issuerStatus = 0;
    } else {
      issuerStatus = 1;
    }
  }
}
