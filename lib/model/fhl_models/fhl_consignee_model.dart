class FHLConsigneeModel {
  String consigneeName = '';
  String consigneeAddress = '';
  String consigneePlace = '';
  String consigneeState = '';
  String consigneeCode = '';
  String consigneePostCode = '';
  String consigneeIdentifier = '';
  String consigneeNumber = '';
  List<Map<String, dynamic>> consigneeContactList = [];
  List<ConsigneeExpenseList> newconsigneeContactList = [];

  clearConsignee() {
    consigneeName = '';
    consigneeAddress = '';
    consigneePlace = '';
    consigneeState = '';
    consigneeCode = '';
    consigneePostCode = '';
    consigneeIdentifier = '';
    consigneeNumber = '';
    consigneeContactList = [];
  }

}

class ConsigneeExpenseList {
  String Consignee_Contact_Type;
  String Consignee_Contact_Detail;
  String flag;
  ConsigneeExpenseList({
    this.Consignee_Contact_Type,
    this.Consignee_Contact_Detail,this.flag,
  });

  Map<String, dynamic> toJson() {
    return {
      'Consignee_Contact_Type': Consignee_Contact_Type,
      'Consignee_Contact_Detail': Consignee_Contact_Detail
    };
  }
}
