class HandlingInformationModel {
  // ! 10 - Handling information....
  String handlingInformationRequirements = "";
  String handlingInformationSCI = "";
  int handlingInformationStatus = 0;

  void clearHandlingInformationModel() {
    this.handlingInformationRequirements = this.handlingInformationSCI = '';
    this.handlingInformationStatus = 0;
  }

  void setStatusHandlingInformationModel() {
    if (handlingInformationRequirements == "" && handlingInformationSCI == "") {
      handlingInformationStatus = 0;
    } else if (handlingInformationRequirements == "" ||
        handlingInformationSCI == "") {
      handlingInformationStatus = -1;
    } else {
      handlingInformationStatus = 1;
    }
  }
}
