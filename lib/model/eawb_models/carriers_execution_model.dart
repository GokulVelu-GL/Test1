class CarriersExecutionModel {
  // ! 16 - Carrier's execution....
  String carriersExecutionRemarks = "";
  String executedOn = "";
  String atPlace = "";
  String signatureOfIssuingCarrier = "";
  int carriersExecutionStatus = 0;

  void clearCarriersExecutionModel() {
    this.executedOn =
        this.atPlace = this.signatureOfIssuingCarrier = ''; //prepaid#collect
    this.carriersExecutionStatus = 0;
  }

  void setStatusCarriersExecutionModel() {
    if (executedOn == "" && atPlace == "" && signatureOfIssuingCarrier == "") {
      carriersExecutionStatus = 0;
    } else if (executedOn == "" ||
        atPlace == "" ||
        signatureOfIssuingCarrier == "") {
      carriersExecutionStatus = -1;
    } else {
      carriersExecutionStatus = 1;
    }
  }
}
