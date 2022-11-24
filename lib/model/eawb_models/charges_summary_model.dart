class ChargesSummaryModel {
  // ! 12 - Charges summary....
  String chargeSummaryWeightChargePrepaid = "0";
  String chargeSummaryWeightChargePostpaid = "";
  String chargeSummaryValuationChargePrepaid = "0";
  String chargeSummaryValuationChargePostpaid = "";
  String chargeSummaryTaxPrepaid = "0";
  String chargeSummaryTaxPostpaid = "";
  String chargeSummaryDueAgentPrepaid = "0";
  String chargeSummaryDueAgentPostpaid = "";
  String chargeSummaryDueCarrierPrepaid = "0";
  String chargeSummaryDueCarrierPostpaid = "";
  String chargeSummaryTotalPrepaid = "";
  String chargeSummaryTotalPostpaid = "";
  int chargeSummaryStatus = 0;

  void clearChargesSummaryModel() {
    this.chargeSummaryWeightChargePrepaid = this.chargeSummaryValuationChargePrepaid =
        this.chargeSummaryTaxPrepaid = this.chargeSummaryDueAgentPrepaid =
            this.chargeSummaryDueCarrierPrepaid = this.chargeSummaryTotalPrepaid =
                this.chargeSummaryWeightChargePostpaid =
                    this.chargeSummaryValuationChargePostpaid =
                        this.chargeSummaryTaxPostpaid = this.chargeSummaryDueAgentPostpaid =
                            this.chargeSummaryDueCarrierPostpaid = this.chargeSummaryTotalPostpaid = "";
    this.chargeSummaryStatus = 0;
  }

  void setStatusChargesSummaryModel() {
    if (chargeSummaryWeightChargePrepaid.length == 0 &&
        chargeSummaryValuationChargePrepaid.length == 0 &&
        chargeSummaryTaxPrepaid.length == 0 &&
        chargeSummaryDueAgentPrepaid.length == 0 &&
        chargeSummaryDueCarrierPrepaid.length == 0 &&
        chargeSummaryTotalPrepaid.length == 0 &&
        chargeSummaryWeightChargePostpaid.length == 0 &&
        chargeSummaryValuationChargePostpaid.length == 0 &&
        chargeSummaryTaxPostpaid.length == 0 &&
        chargeSummaryDueAgentPostpaid.length == 0 &&
        chargeSummaryDueCarrierPostpaid.length == 0 &&
        chargeSummaryTotalPostpaid.length == 0) {
      chargeSummaryStatus = 0;
    } else if (chargeSummaryWeightChargePrepaid.length == 0 ||
        chargeSummaryValuationChargePrepaid.length == 0 ||
        chargeSummaryTaxPrepaid.length == 0 ||
        chargeSummaryDueAgentPrepaid.length == 0 ||
        chargeSummaryDueCarrierPrepaid.length == 0 ||
        chargeSummaryTotalPrepaid.length == 0 ||
        chargeSummaryWeightChargePostpaid.length == 0 ||
        chargeSummaryValuationChargePostpaid.length == 0 ||
        chargeSummaryTaxPostpaid.length == 0 ||
        chargeSummaryDueAgentPostpaid.length == 0 ||
        chargeSummaryDueCarrierPostpaid.length == 0 ||
        chargeSummaryTotalPostpaid.length == 0) {
      chargeSummaryStatus = -1;
    } else {
      chargeSummaryStatus = 1;
    }
  }
}
