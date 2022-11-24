class IssuingCarriersAgentModel {
  // ! 3 - Issuing carrier's agent....
  String issuingCarrierAgentName = "";
  String issuingCarrierAgentCity = "";
  String issuingCarrierAgentPlace = "";
  String issuingCarrierAgentCassAddress = "";
  String issuingCarrierAgentIATACode = "";
  String issuingCarrierAgentAccountNumber = "";
  int issuingCarrierAgentStatus = 0;

  void clearIssuingCarriersAgentModel() {
    this.issuingCarrierAgentName = this.issuingCarrierAgentCity =
        this.issuingCarrierAgentPlace = this.issuingCarrierAgentCassAddress =
            this.issuingCarrierAgentIATACode =
                this.issuingCarrierAgentAccountNumber = '';
    this.issuingCarrierAgentStatus = 0;
  }

  void setStatusIssuingCarriersAgentModel() {
    if (issuingCarrierAgentName == "" &&
        issuingCarrierAgentCity == "" &&
        issuingCarrierAgentIATACode == "" &&
        issuingCarrierAgentPlace == "" &&
        issuingCarrierAgentCassAddress == "" &&
        issuingCarrierAgentAccountNumber == "") {
      issuingCarrierAgentStatus = 0;
    }
    else  if (issuingCarrierAgentName != "" &&
        issuingCarrierAgentPlace != "" ) {
      issuingCarrierAgentStatus = 1;
    }
    else if (issuingCarrierAgentName == "" ||
        issuingCarrierAgentCity == "" ||
        issuingCarrierAgentPlace == "" ||
        issuingCarrierAgentCassAddress == "" ||
        issuingCarrierAgentIATACode == "" ||
        issuingCarrierAgentAccountNumber == "") {
      issuingCarrierAgentStatus = -1;
    }

    else {
      issuingCarrierAgentStatus = 1;
    }
  }
}
