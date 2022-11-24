class ConsigneeModel {
  // ! 2 - Consignee....
  String consigneeAccountNumber = "";
  String consigneeName = "";
  String consigneeAddress = "";
  String consigneePlace = "";
  String consigneeState = "";
  String consigneeCountryCode = "";
  String consigneePostCode = "";
  List<Map<String, dynamic>> consigneeContactList = [];
  List<ConsigneeExpenseList> newconsigneeContactList = [];
  String consigneeContactType = "";
  String consigneeContactNumber = "";
  int consigneeStatus = 0;

  void clearConsigneeModel() {
    consigneeAccountNumber = '';
    consigneeAddress = '';
    consigneeName = '';
    consigneePlace = "";
    consigneeState = "";
    consigneeCountryCode = "";
    consigneePostCode = "";
    newconsigneeContactList.clear();
    // consigneeContactType = "";
    // consigneeContactNumber = "";
    this.consigneeStatus = 0;
  }

  void setStatusConsigneeModel() {
    if (consigneeAccountNumber == "" &&
        consigneeName == "" &&
        consigneeAddress == "" &&
        consigneePlace == "" &&
        consigneeState == "" &&
        consigneeCountryCode == "" &&
        consigneePostCode == "") {
      consigneeStatus = 0;
    }
    else  if (
    // consigneeAccountNumber == "" &&
        consigneeName == "" &&
        consigneeCountryCode == "") {
      consigneeStatus = 1;
    }
    else if (consigneeAccountNumber == "" ||
        consigneeName == "" ||
        consigneeAddress == "" ||
        consigneePlace == "" ||
        consigneeState == "" ||
        consigneeCountryCode == "" ||
        consigneePostCode == "") {
      consigneeStatus = -1;
    }

    else {
      consigneeStatus = 1;
    }
  }
}

class ConsigneeExpenseList {
  String Consignee_Contact_Type;
  String Consignee_Contact_Detail;
  String flag;

  ConsigneeExpenseList({
    this.Consignee_Contact_Type,
    this.Consignee_Contact_Detail,
    this.flag
  });

  Map<String, dynamic> toJson() {
    return {
      'Consignee_Contact_Type': Consignee_Contact_Type,
      'Consignee_Contact_Detail': Consignee_Contact_Detail
    };
  }
}
