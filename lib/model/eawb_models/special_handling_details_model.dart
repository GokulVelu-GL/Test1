class SpecialHandlingModel {
  // !  - SpecialHandlingDetails....
  String SPH1 = "";
  String SPH2 = "";
  String SPH3 = "";
  String SPH4 = "";
  String SPH5 = "";
  String SPH6 = "";
  String SPH7 = "";
  String SPH8 = "";
  String SPH9 = "";
  String SpecialServiceRequest="";
  String OtherServiceInformation ="";
  String SCI="";
  int SpecialHandlingDetailsStatus = 0;

  void clearSpecialHandlingModel() {
     SPH1 = "";
     SPH2 = "";
     SPH3 = "";
     SPH4 = "";
     SPH5 = "";
     SPH6 = "";
     SPH7 = "";
     SPH8 = "";
     SPH9 = "";
     SpecialServiceRequest="";
     OtherServiceInformation ="";
     SCI="";
     this.SpecialHandlingDetailsStatus = 0;
  }

  void setStatusSpecialHandlingDetailsModel() {
    if (
    SPH1 == "" &&  SPH2 == "" &&
    // SPH3 == "" &&
    // SPH4 == ""&&
    // SPH5 == ""&&
    // SPH6 == ""&&
    // SPH7 == ""&&
    // SPH8 == ""&&
    // SPH9 ==""&&
    SpecialServiceRequest==""&&
    OtherServiceInformation ==""&&
    SCI==""


    // consigneeAccountNumber == "" &&
    //     consigneeName == "" &&
    //     consigneeAddress == "" &&
    //     consigneePlace == "" &&
    //     consigneeState == "" &&
    //     consigneeCountryCode == "" &&
    //     consigneePostCode == ""

    ) {
      SpecialHandlingDetailsStatus = 0;
    }

    else if
    (
    SPH1 == "" ||  SPH2 == "" ||
        // SPH3 == "" ||
        // SPH4 == ""||
        // SPH5 == ""||
        // SPH6 == ""||
        // SPH7 == ""||
        // SPH8 == ""||
        // SPH9 ==""||
        SpecialServiceRequest==""||
        OtherServiceInformation ==""||
        SCI==""
    ) {
      SpecialHandlingDetailsStatus = -1;


    } else {
      SpecialHandlingDetailsStatus = 1;
    }
  }
}
