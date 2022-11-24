import 'package:rooster/model/other_charges_items.dart';

class OtherChargesModel {
  // ! 14 - Other charges (add, modify, remove)....
  List<OtherChargesItem> otherChargesList = new List<OtherChargesItem>();

  int otherChargesStatus = 0;

  // ? where int is index and list is table value....

  void clearOtherChargesModel() {
    this.otherChargesList.clear();
    this.otherChargesStatus = 0;
  }

  void setStatusOtherChargesModel() {
    if (otherChargesList.length == 0) {
      otherChargesStatus = 0;
    } else {
      otherChargesStatus = 1;
    }
  }
}
