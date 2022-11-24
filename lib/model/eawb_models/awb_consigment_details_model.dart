class AWBConsigmentDetailsModel {
  // ! 5- AWB consigment details....
  String awbConsigmentDetailsAWBNumber = "";
  String awbConsigmentDetailsDepAirportCode = "";
  String awbConsigmentOriginPrefix = "";
  String awbConsigmentDestination = "";
  String awbConsigmentPices = "";
  String awbConsigmentWeightCode = "K";
  String awbConsigmentWeight = "";
  String awbConsigmentVolumeCode = "T";
  String awbConsigmentVolume = "";
  String awbConsigmentDensity = "";
  int awbConsigmentDetailsStatus = 0;

  void clearAWBConsigmentDetailsModel() {
    this.awbConsigmentDetailsDepAirportCode = '';
    this.awbConsigmentOriginPrefix = "";
    this.awbConsigmentDestination = "";
    this.awbConsigmentPices = "";
    // this.awbConsigmentWeightCode = "";
    this.awbConsigmentWeight = "";
    // this.awbConsigmentVolumeCode = "";
    this.awbConsigmentVolume = "";
    this.awbConsigmentDensity = "";
    this.awbConsigmentDetailsStatus = 0;
  }

  void setStatusAWBConsigmentDetailsModel() {
    if (
    awbConsigmentDetailsAWBNumber == "" &&
        awbConsigmentOriginPrefix == "" &&
        awbConsigmentDestination == "" &&
        awbConsigmentPices == "" &&
        awbConsigmentWeightCode == "" &&
        awbConsigmentWeight == "" &&
        awbConsigmentVolumeCode == "" &&
        awbConsigmentVolume == ""
           //&&
        // awbConsigmentDensity == ""
    // &&
    //     awbConsigmentDetailsDepAirportCode == ""
    ) {
      awbConsigmentDetailsStatus = 0;
    }
    else if (
    awbConsigmentDetailsAWBNumber != "" &&
    awbConsigmentOriginPrefix != ""&&
    awbConsigmentDestination != "" &&
    awbConsigmentPices != "" &&
    awbConsigmentWeightCode != "" &&
    awbConsigmentWeight != ""
    ){
      awbConsigmentDetailsStatus = 1;
    }
    else if (
    awbConsigmentDetailsAWBNumber == "" ||
        awbConsigmentOriginPrefix == "" ||
        awbConsigmentDestination == "" ||
        awbConsigmentPices == "" ||
        awbConsigmentWeightCode == "" ||
        awbConsigmentWeight == "" ||
        awbConsigmentVolumeCode == "" ||
        awbConsigmentVolume == "" ||
        awbConsigmentDensity == ""
        //    ||
        // awbConsigmentDetailsDepAirportCode == ""
    ) {
      awbConsigmentDetailsStatus = -1;
    } else {
      awbConsigmentDetailsStatus = 1;
    }
  }
}
