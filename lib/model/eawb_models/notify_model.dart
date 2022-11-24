class NotifyModel {
  String notifyName = "";
  String nofityStreetAddress = "";
  String notifyPlace = "";
  String notifyState = "";
  String notifyCountryCode = "";
  String notifyPostCode = "";
  String notifyContactType = "";
  String notifyContactNumber = "";
  int notifyStatus = 0;
  List<NotifyExpenseList> newnotifyContactList = [];

  void clearNotify() {
    this.notifyName = this.nofityStreetAddress = this.notifyPlace =
        this.notifyState = this.notifyCountryCode = this.notifyPostCode =
            this.notifyContactType = this.notifyContactNumber;
    this.newnotifyContactList.clear();
  }

  void setNotifyStatus() {
    if (notifyName == "" &&
        nofityStreetAddress == "" &&
        notifyPlace == "" &&
        notifyState == "" &&
        notifyCountryCode == "" &&
        notifyPostCode == ""
        // &&
        // notifyContactType == "" &&
        // notifyContactNumber == ""
    ) {
      notifyStatus = 0;
    } else if (notifyName == "" ||
        nofityStreetAddress == "" ||
        notifyPlace == "" ||
        notifyState == "" ||
        notifyCountryCode == "" ||
        notifyPostCode == ""
        // ||
        // notifyContactType == "" ||
        // notifyContactNumber == ""
    ) {
      notifyStatus = -1;
    } else {
      notifyStatus = 1;
    }
  }
}

class NotifyExpenseList {
  String Notify_Contact_Type;
  String Notify_Contact_Detail;
  String flag;
  NotifyExpenseList({
    this.Notify_Contact_Type,
    this.Notify_Contact_Detail,
    this.flag,
  });
  Map<String, dynamic> toJson() {
    return {
      'Notify_Contact1_Type': Notify_Contact_Type,
      'Notify_Contact1_Detail': Notify_Contact_Detail
    };
  }
}
